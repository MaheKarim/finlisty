import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/data/firebase_constants.dart';
import '../models/transaction_model.dart';
import '../../domain/entities/transaction_entity.dart';

abstract class TransactionRemoteDataSource {
  Future<void> addTransaction(TransactionModel transaction);
  Future<List<TransactionModel>> getTransactions();
  Stream<List<TransactionModel>> getTransactionsStream();
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  TransactionRemoteDataSourceImpl({required this.firestore, required this.auth});

  DocumentReference get _userDoc {
    final uid = auth.currentUser?.uid;
    if (uid == null) throw Exception('User not authenticated');
    return firestore.collection(FirebaseConstants.users).doc(uid);
  }

  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    final userDocRef = _userDoc;
    final walletRef = userDocRef.collection(FirebaseConstants.wallets).doc(transaction.walletId);
    final transactionCollRef = userDocRef.collection(FirebaseConstants.transactions);

    await firestore.runTransaction((txn) async {
      // 1. Read Source Wallet
      final walletSnapshot = await txn.get(walletRef);
      if (!walletSnapshot.exists) {
        throw Exception("Source wallet does not exist!");
      }

      final double currentBalance = (walletSnapshot.data()?['balance'] ?? 0.0).toDouble();

      // 2. Handle Logic based on Type
      if (transaction.type == TransactionType.expense) {
        final newBalance = currentBalance - transaction.amount;
        txn.update(walletRef, {'balance': newBalance});
      } else if (transaction.type == TransactionType.income) {
        final newBalance = currentBalance + transaction.amount;
        txn.update(walletRef, {'balance': newBalance});
      } else if (transaction.type == TransactionType.transfer) {
        // Transfer Logic
        if (transaction.destinationWalletId == null) {
            throw Exception("Destination wallet is required for transfer");
        }
        
        final destWalletRef = userDocRef.collection(FirebaseConstants.wallets).doc(transaction.destinationWalletId);
        final destWalletSnapshot = await txn.get(destWalletRef);
        
        if (!destWalletSnapshot.exists) {
             throw Exception("Destination wallet does not exist!");
        }

        final double destBalance = (destWalletSnapshot.data()?['balance'] ?? 0.0).toDouble();
        
        // Deduct from Source
        txn.update(walletRef, {'balance': currentBalance - transaction.amount});
        // Add to Destination
        txn.update(destWalletRef, {'balance': destBalance + transaction.amount});
      }

      // 3. Create Transaction Record
      final newTxnRef = transactionCollRef.doc(); // Generate ID
      txn.set(newTxnRef, transaction.toJson());
    });
  }

  @override
  Stream<List<TransactionModel>> getTransactionsStream() {
    final uid = auth.currentUser?.uid;
    if (uid == null) return const Stream.empty();

    return firestore
        .collection(FirebaseConstants.users)
        .doc(uid)
        .collection(FirebaseConstants.transactions)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => TransactionModel.fromSnapshot(doc)).toList());
  }

  @override
  Future<List<TransactionModel>> getTransactions() async {
    // Basic fetch, usually heavily filtered in real apps
    final snapshot = await _userDoc
        .collection(FirebaseConstants.transactions)
        .orderBy('date', descending: true)
        .limit(50)
        .get();
        
    return snapshot.docs.map((doc) => TransactionModel.fromSnapshot(doc)).toList();
  }
}
