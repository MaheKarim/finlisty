# Firebase Data Model & Design

## 1. Firestore Schema

All data is scoped under the `users` collection to ensure isolation and simplify security rules.

### **Collection: `users`**
Document ID: `userId` (from Auth)
Fields:
- `email`: string
- `displayName`: string
- `createdAt`: timestamp
- `currency`: string (default "BDT")
- `language`: string (default "bn")
- `fcmTokens`: array of strings

---

### **Sub-collection: `wallets`**
Path: `users/{userId}/wallets/{walletId}`
Fields:
- `name`: string (e.g., "Main Cash", "My bKash")
- `type`: string ("cash" | "bkash" | "bank" | "nagad")
- `balance`: number (float)
- `color`: string (hex code)
- `isArchived`: boolean (default false)
- `updatedAt`: timestamp

---

### **Sub-collection: `transactions`**
Path: `users/{userId}/transactions/{txnId}`
Fields:
- `amount`: number
- `type`: string ("income" | "expense" | "transfer")
- `walletId`: string (reference to source wallet)
- `destinationWalletId`: string (nullable, only for transfers)
- `categoryId`: string (nullable)
- `categoryName`: string (denormalized for easy querying)
- `date`: timestamp
- `note`: string
- `loanId`: string (nullable, if linked to a loan)
- `createdAt`: timestamp

---

### **Sub-collection: `categories`**
Path: `users/{userId}/categories/{catId}`
Fields:
- `nameEn`: string
- `nameBn`: string
- `icon`: string (material icon code or asset path)
- `type`: string ("income" | "expense")
- `isDefault`: boolean

---

### **Sub-collection: `loans`**
Path: `users/{userId}/loans/{loanId}`
Fields:
- `personName`: string
- `type`: string ("GIVEN" | "TAKEN")
- `principalAmount`: number
- `outstandingAmount`: number (auto-calculated)
- `interestRate`: number (optional)
- `startDate`: timestamp
- `dueDate`: timestamp
- `status`: string ("active" | "closed")
- `notes`: string

### **Sub-sub-collection: `loan_payments`**
Path: `users/{userId}/loans/{loanId}/payments/{paymentId}`
Fields:
- `amount`: number
- `date`: timestamp
- `walletId`: string
- `type`: string ("repayment" | "disbursement")

---

### **Sub-collection: `recurring_bills`**
Path: `users/{userId}/recurring_bills/{billId}`
Fields:
- `title`: string
- `amount`: number
- `frequency`: string ("weekly" | "monthly")
- `nextDueDate`: timestamp
- `isActive`: boolean
- `fcmToken`: string (optional, for device targeting)

---

## 2. Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Helper function to check ownership
    function isOwner(userId) {
      return request.auth != null && request.auth.uid == userId;
    }

    // Match any document in the 'users' collection
    match /users/{userId} {
      allow read, write: if isOwner(userId);
      
      // Match all subcollections recursively
      match /{document=**} {
        allow read, write: if isOwner(userId);
      }
    }
  }
}
```

## 3. Cloud Functions (Design)

### Function 1: `sendBillReminders`
- **Trigger**: Scheduled (Pub/Sub) - Runs every day at 10:00 AM BDT.
- **Logic**:
  1. Query `users/{userId}/recurring_bills` where `nextDueDate` is tomorrow.
  2. For each bill, fetch the user's FCM tokens.
  3. Send a notification:
     - Title: "Bill Reminder 💸"
     - Body: "Your bill {billName} of ৳{amount} is due tomorrow."

### Function 2: `updateLoanStatus` (Optional)
- **Trigger**: Firestore `onUpdate` for `loans/{loanId}`.
- **Logic**:
  - If `outstandingAmount` <= 0, automatically set `status` to "closed".
