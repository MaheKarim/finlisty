import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/data/firebase_constants.dart';
import '../models/loan_model.dart';

abstract class LoanRemoteDataSource {
  Future<void> addLoan(LoanModel loan);
  Future<List<LoanModel>> getLoans();
  Stream<List<LoanModel>> getLoansStream();
  Future<void> updateLoanStatus(String loanId, String status);
  Future<void> repayLoan(String loanId, double amount, String walletId, bool isLoanGiven);
}

class LoanRemoteDataSourceImpl implements LoanRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  LoanRemoteDataSourceImpl({required this.firestore, required this.auth});

  DocumentReference get _userDoc {
    final uid = auth.currentUser?.uid;
    if (uid == null) throw Exception('User not authenticated');
    return firestore.collection(FirebaseConstants.users).doc(uid);
  }

  @override
  Future<void> addLoan(LoanModel loan) async {
     await _userDoc.collection(FirebaseConstants.loans).add(loan.toJson());
  }

  @override
  Future<List<LoanModel>> getLoans() async {
    final snapshot = await _userDoc
        .collection(FirebaseConstants.loans)
        .orderBy('startDate', descending: true)
        .get();
    return snapshot.docs.map((doc) => LoanModel.fromSnapshot(doc)).toList();
  }

  @override
  Stream<List<LoanModel>> getLoansStream() {
    final uid = auth.currentUser?.uid;
    if (uid == null) return const Stream.empty();

    return firestore
        .collection(FirebaseConstants.users)
        .doc(uid)
        .collection(FirebaseConstants.loans)
        .orderBy('startDate', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => LoanModel.fromSnapshot(doc)).toList());
  }

  @override
  Future<void> updateLoanStatus(String loanId, String status) async {
    await _userDoc
        .collection(FirebaseConstants.loans)
        .doc(loanId)
        .update({'status': status});
  }

  @override
  Future<void> repayLoan(String loanId, double amount, String walletId, bool isLoanGiven) async {
    final loanRef = _userDoc.collection(FirebaseConstants.loans).doc(loanId);
    final walletRef = _userDoc.collection(FirebaseConstants.wallets).doc(walletId);
    final paymentRef = loanRef.collection(FirebaseConstants.loanPayments).doc();

    await firestore.runTransaction((txn) async {
      // 1. Get Loan
      final loanSnap = await txn.get(loanRef);
      if (!loanSnap.exists) throw Exception("Loan not found");
      
      final currentOutstanding = (loanSnap.data()?['outstandingAmount'] ?? 0.0).toDouble();
      final newOutstanding = currentOutstanding - amount;
      
      // 2. Get Wallet
      final walletSnap = await txn.get(walletRef);
      if (!walletSnap.exists) throw Exception("Wallet not found");
      
      final currentBalance = (walletSnap.data()?['balance'] ?? 0.0).toDouble();
      
      // 3. Calc new balance
      // If Given (Lend) -> Repayment comes in -> +Balance
      // If Taken (Borrow) -> Repayment goes out -> -Balance
      final newBalance = isLoanGiven ? (currentBalance + amount) : (currentBalance - amount);

      // 4. Writes
      txn.update(loanRef, {
        'outstandingAmount': newOutstanding,
        'status': newOutstanding <= 0 ? 'closed' : 'active',
      });

      txn.update(walletRef, {'balance': newBalance});

      txn.set(paymentRef, {
        'amount': amount,
        'date': FieldValue.serverTimestamp(),
        'walletId': walletId,
        'type': 'repayment',
      });
    });
  }
}
