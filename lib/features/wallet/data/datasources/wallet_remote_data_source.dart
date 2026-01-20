import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/data/firebase_constants.dart';
import '../models/wallet_model.dart';

abstract class WalletRemoteDataSource {
  Future<List<WalletModel>> getWallets();
  Stream<List<WalletModel>> getWalletsStream();
  Future<void> addWallet(WalletModel wallet);
  Future<void> updateWallet(WalletModel wallet);
  Future<void> deleteWallet(String id);
}

class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  WalletRemoteDataSourceImpl({required this.firestore, required this.auth});

  // Helper to get User Doc Ref
  DocumentReference get _userDoc {
    final uid = auth.currentUser?.uid;
    if (uid == null) throw Exception('User not authenticated');
    return firestore.collection(FirebaseConstants.users).doc(uid);
  }

  @override
  Future<List<WalletModel>> getWallets() async {
    try {
      final snapshot = await _userDoc.collection(FirebaseConstants.wallets).get();
      return snapshot.docs.map((doc) => WalletModel.fromSnapshot(doc)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Stream<List<WalletModel>> getWalletsStream() {
    // Note: In production code, handle auth state changes more gracefully
    final uid = auth.currentUser?.uid;
    if (uid == null) return const Stream.empty();

    return firestore
        .collection(FirebaseConstants.users)
        .doc(uid)
        .collection(FirebaseConstants.wallets)
        .orderBy('name')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => WalletModel.fromSnapshot(doc)).toList());
  }

  @override
  Future<void> addWallet(WalletModel wallet) async {
    await _userDoc.collection(FirebaseConstants.wallets).add(wallet.toJson());
  }

  @override
  Future<void> updateWallet(WalletModel wallet) async {
    await _userDoc
        .collection(FirebaseConstants.wallets)
        .doc(wallet.id)
        .update(wallet.toJson());
  }

  @override
  Future<void> deleteWallet(String id) async {
    await _userDoc.collection(FirebaseConstants.wallets).doc(id).delete();
  }
}
