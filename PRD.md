You are a senior Flutter + Firebase architect and product engineer. If You need to install anything for this app please proceed

Build a production-ready MVP of a Personal Finance mobile app for Bangladesh
using Flutter (Android-first) and Firebase, following Clean Architecture.

The app helps users manage:
- Income
- Expense
- Transfer
- Multiple Wallets (Cash, bKash, Bank)
- Loan & Debt (Given and Taken)
and clearly understand monthly financial health through analytics.

========================
1. CORE REQUIREMENTS
========================

Platform:
- Flutter (latest stable)
- Firebase (Auth, Firestore, Cloud Functions, FCM)

Architecture:
- Clean Architecture
- MVVM
- Feature-first modular structure
- Offline-first where possible

========================
2. FEATURES (MVP SCOPE)
========================

--------------------------------
A. Wallet Management
--------------------------------
- Support multiple wallets:
  - Cash
  - bKash
  - Bank
- Each wallet has:
  - name
  - type
  - balance
- Wallet balance auto-updates based on transactions

--------------------------------
B. Transactions
--------------------------------
Support 3 transaction types:
1. Income
2. Expense
3. Transfer (wallet → wallet)

Common fields:
- amount
- wallet
- date
- note (optional)

Expense-specific:
- category-based expense
- payment method: Cash / bKash / Nagad

Transfer logic:
- Deduct from source wallet
- Add to destination wallet
- Use Firestore atomic transaction

--------------------------------
C. Expense Categories
--------------------------------
Default categories:
- Food
- Transport
- Rent
- Bill
- Shopping
- Health
- Others

Each category must support:
- English name
- Bangla name
- icon

--------------------------------
D. Recurring Expense (Bills)
--------------------------------
- User can create recurring bills
- Frequency:
  - Monthly
  - Weekly
- Track next due date automatically

--------------------------------
E. Bill Reminder
--------------------------------
- Use Firebase Cloud Functions (scheduled)
- Send FCM notification 1 day before due date
- Notification includes:
  - bill name
  - amount
  - due date

--------------------------------
F. Loan & Debt Management (NEW)
--------------------------------

Support two types:
1. Loan Given (Others owe user)
2. Loan Taken (User owes others)

Each loan includes:
- personName
- loanType: given | taken
- principalAmount
- interestRate (optional)
- startDate
- dueDate (optional)
- status: active | closed
- linked wallet (optional)

Loan actions:
- Add loan
- Partial repayment
- Full settlement
- Auto-adjust wallet balance on repayment

--------------------------------
G. Loan & Debt Analytics (NEW)
--------------------------------

Analytics must show:
- Total loan given
- Total loan taken
- Outstanding amount (net position)
- Monthly loan repayment summary
- Overdue loans list
- Active vs closed loans count

Optional simple visualization:
- Bar chart (loan vs debt)
- List-based overdue alerts

--------------------------------
H. Analytics & Dashboard
--------------------------------

Dashboard must show:
- Monthly summary:
  - Total income
  - Total expense
  - Net balance
- Category-wise expense pie chart
- Top 3 expense categories
- Loan snapshot:
  - Outstanding loan
  - Outstanding debt

Analytics should be computed using:
- Firestore aggregation queries
- Cloud Functions if required for performance

--------------------------------
I. Language & UI
--------------------------------
- Bangla + English UI
- Language switch from settings
- Use intl + JSON translations
- Light & Dark mode

========================
3. FIREBASE DATA MODEL
========================

Design Firestore collections for:
- users
- wallets
- transactions
- categories
- recurring_bills
- loans
- loan_payments

Ensure:
- userId-based data isolation
- scalable indexing
- minimal read/write cost

========================
4. SECURITY
========================

- Firebase Auth (Anonymous or Google)
- Firestore security rules:
  - Users can access only their own data
- Local app security:
  - PIN / Biometric lock

========================
5. UI / UX DESIGN INSTRUCTIONS (IMPORTANT)
========================

Design style:
- Modern, clean, minimal
- Finance-grade (trustworthy, calm)
- No clutter, high readability

Design principles:
- Use whitespace generously
- Soft shadows, rounded cards
- Clear hierarchy (Balance > Summary > Details)
- One primary CTA per screen

Color system:
- Neutral background (light gray / off-white)
- Primary accent color (green / teal)
- Red only for negative (expense, debt)
- Green for positive (income, loan given)

Typography:
- Large balance numbers
- Medium section headers
- Small helper text
- Avoid decorative fonts

Dashboard layout:
- Top: Total balance
- Middle: Monthly summary cards
- Bottom: Charts + insights

Charts:
- Simple, flat design
- No 3D charts
- Clear legends
- Touch-friendly

Forms:
- Minimal input fields
- Numeric keypad for amount
- Clear validation errors
- Primary action button fixed at bottom

========================
6. OUTPUT EXPECTATION
========================

Provide:
1. Flutter folder structure (Clean Architecture)
2. Firestore schema (all collections)
3. Firestore security rules
4. Cloud Functions:
   - Bill reminder
   - Loan overdue reminder (optional)
5. Example Flutter screens:
   - Dashboard
   - Add Expense
   - Add Income
   - Transfer
   - Loan Add / Repayment
6. Clear comments and documentation

Do NOT include:
- Investment
- Bank API integration
- AI predictions
- Family / multi-user features

Focus strictly on MVP quality, clarity, and long-term scalability.