You are a senior Flutter + Firebase architect and product engineer.

Your task is to BUILD a production-ready MVP of a Personal Finance mobile app for Bangladesh using Flutter (Android-first) and Firebase.

This is NOT a prototype.
This is a real-world MVP for real users.

If any dependency, Flutter package, Firebase setup, or configuration is required,
you are AUTHORIZED to install and configure it.

You MUST follow:
- Clean Architecture
- MVVM
- Feature-first modular structure
- Offline-first approach where possible

You MUST NOT skip any feature.
You MUST perform ALL verification checks before finalizing.

════════════════════════════
PHASE 0 — SYSTEM SETUP
════════════════════════════

Platform:
• Flutter (latest stable)
• Android-first

Backend:
• Firebase Authentication
• Cloud Firestore
• Firebase Cloud Messaging (optional for future)

Architecture:
• Clean Architecture
• MVVM
• Feature-first modules
• Offline-first (Firestore cache)

UI / UX:
• Strictly follow @design_guide.md
• Do NOT introduce new colors, fonts, spacing, or components

════════════════════════════
PHASE 1 — DATA & DOMAIN DESIGN
════════════════════════════

Design Firestore collections:

• users
• wallets
• transactions
• categories
• recurring_bills
• loans
• loan_payments

Rules:
• Every document MUST be scoped by userId
• Index collections for scalability
• Minimize read/write cost
• Prepare schema for offline sync

════════════════════════════
PHASE 2 — AUTHENTICATION & SECURITY
════════════════════════════

Implement:
• Firebase Authentication
  - Email + Password OR Google Sign-in
• Secure Firestore Rules:
  - Users can read/write ONLY their own data
• Local App Lock:
  - PIN or Biometric

════════════════════════════
PHASE 3 — CORE PRODUCT FEATURES
════════════════════════════

--------------------------------
A. WALLET MANAGEMENT
--------------------------------
Wallet types:
• Cash
• bKash
• Bank

Wallet fields:
• name
• type
• balance

Rules:
• Wallet balance auto-updates from transactions
• Wallet-wise balance MUST appear on Dashboard

--------------------------------
B. TRANSACTIONS
--------------------------------
Supported types:
1. Income
2. Expense
3. Transfer (wallet → wallet)

Common fields:
• amount
• wallet
• date
• note (optional)

Expense:
• Category-based
• Payment method: Cash / bKash / Nagad

Transfer:
• Atomic Firestore transaction
• Deduct from source wallet
• Add to destination wallet

--------------------------------
C. EXPENSE CATEGORIES
--------------------------------
Default categories:
• Food
• Transport
• Rent
• Bill
• Shopping
• Health
• Others

Each category MUST include:
• English name
• Bangla name
• Icon

--------------------------------
D. RECURRING EXPENSE (BILLS)
--------------------------------
• Monthly or Weekly
• Auto-calculate next due date

--------------------------------
E. LOAN & DEBT MANAGEMENT
--------------------------------
Loan types:
1. Loan Given (Others owe user)
2. Loan Taken (User owes others)

Loan fields:
• personName
• loanType (given | taken)
• principalAmount
• startDate
• dueDate (optional)
• status (active | closed)
• linkedWallet (optional)

STRICT RULE:
❌ NO interest rate
❌ NO interest calculation

Loan actions:
• Add loan
• Partial repayment
• Full settlement
• Auto wallet balance adjustment

Loan Taken additional rule:
• Fixed recurring monthly payment
• Monthly auto-deduction
• Reduce remaining balance
• Maintain payment history

--------------------------------
F. LOAN & DEBT ANALYTICS
--------------------------------
Show:
• Total loan given
• Total loan taken
• Net outstanding position
• Monthly repayment summary
• Overdue loans list
• Active vs Closed count

Visualization:
• Simple bar chart (Loan vs Debt)
• List-based overdue alerts

--------------------------------
G. DASHBOARD & ANALYTICS
--------------------------------
Dashboard:
• Monthly income
• Monthly expense
• Net balance
• Wallet-wise balances
• Loan snapshot (outstanding loan & debt)

Analytics:
• Category-wise expense pie chart
• Top 3 expense categories
• Daily-wise expense visualization:
  - Bar chart (daily expense)
  - Line chart overlay (trend)
• Default range: Last 7 days

--------------------------------
H. UI, LANGUAGE & NAVIGATION
--------------------------------
• Bangla + English UI
• intl + JSON translations
• Language switch from settings
• Light & Dark mode

Navigation:
• Bottom navigation bar on ALL main pages:
  - Dashboard
  - Transactions
  - Analytics
  - Profile / Settings

════════════════════════════
PHASE 4 — FIREBASE SYSTEM HEALTH CHECK (NEW)
════════════════════════════

After login, the app MUST automatically verify:

• Firebase Auth state is valid
• User document exists in Firestore
• Required collections are accessible
• Security rules allow correct access
• Offline cache is working correctly

If any check fails:
• Show a safe fallback UI
• Log the issue
• Prevent app crash

════════════════════════════
PHASE 5 — UI IMPLEMENTATION
════════════════════════════

Implement example screens:
• Login / Registration
• Dashboard
• Add Income
• Add Expense
• Transfer
• Loan Add
• Loan Repayment
• Analytics
• Settings

Rules:
• Follow @design_guide.md strictly
• Calm, clean, finance-grade UI
• No visual clutter
• Numbers must be prioritized

════════════════════════════
PHASE 6 — OUTPUT EXPECTATION
════════════════════════════

Provide:
1. Flutter folder structure (Clean Architecture)
2. Firestore schema (all collections)
3. Firestore security rules
4. Firebase Auth + Health Check logic
5. Example Flutter screens
6. Clear inline comments & documentation

════════════════════════════
PHASE 7 — FINAL SELF-AUDIT (MANDATORY)
════════════════════════════

Before finalizing, VERIFY ALL items:

☐ Firebase login works correctly  
☐ Firebase health check passes  
☐ Firestore rules enforced  
☐ Wallet-wise balance correct  
☐ Income / Expense / Transfer accurate  
☐ Atomic wallet transfer works  
☐ Categories bilingual  
☐ Recurring bills logic correct  
☐ Loan given & taken (NO interest)  
☐ Loan recurring monthly payment  
☐ Loan analytics implemented  
☐ Dashboard analytics complete  
☐ Daily bar + line chart present  
☐ Bottom navigation on all pages  
☐ Clean Architecture respected  
☐ @design_guide.md fully followed  

If ANY item is missing, FIX IT before completion.

This app MUST feel:
• Trustworthy
• Calm
• Clean
• Production-ready