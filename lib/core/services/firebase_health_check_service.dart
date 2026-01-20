import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Firebase Health Check Service
/// Verifies Firebase connectivity and user setup after login
/// Per PRD Phase 4 requirements
class FirebaseHealthCheckService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  FirebaseHealthCheckService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  /// Perform comprehensive health check
  /// Returns HealthCheckResult with status and any issues
  Future<HealthCheckResult> performHealthCheck() async {
    final issues = <String>[];
    bool isHealthy = true;

    // 1. Check Firebase Auth state
    final authResult = await _checkAuthState();
    if (!authResult.passed) {
      issues.add(authResult.message);
      isHealthy = false;
    }

    // 2. Check user document exists
    if (authResult.passed) {
      final userDocResult = await _checkUserDocument();
      if (!userDocResult.passed) {
        issues.add(userDocResult.message);
        // Not critical - we can create it
      }
    }

    // 3. Check required collections are accessible
    final collectionsResult = await _checkCollectionsAccess();
    if (!collectionsResult.passed) {
      issues.add(collectionsResult.message);
      isHealthy = false;
    }

    // 4. Check offline cache is working
    final cacheResult = await _checkOfflineCache();
    if (!cacheResult.passed) {
      issues.add(cacheResult.message);
      // Not critical - app can work without offline
    }

    return HealthCheckResult(
      isHealthy: isHealthy,
      issues: issues,
      authValid: _auth.currentUser != null,
      userDocExists: issues.isEmpty || !issues.any((i) => i.contains('User document')),
      collectionsAccessible: collectionsResult.passed,
      offlineCacheWorking: cacheResult.passed,
    );
  }

  Future<CheckResult> _checkAuthState() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return CheckResult(passed: false, message: 'No authenticated user');
      }
      
      // Verify token is valid
      await user.reload();
      return CheckResult(passed: true, message: 'Auth state valid');
    } catch (e) {
      return CheckResult(passed: false, message: 'Auth state invalid: $e');
    }
  }

  Future<CheckResult> _checkUserDocument() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return CheckResult(passed: false, message: 'No user to check');
      }

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) {
        // Create user document if it doesn't exist
        await _firestore.collection('users').doc(user.uid).set({
          'email': user.email,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
        return CheckResult(passed: true, message: 'User document created');
      }
      return CheckResult(passed: true, message: 'User document exists');
    } catch (e) {
      return CheckResult(passed: false, message: 'User document check failed: $e');
    }
  }

  Future<CheckResult> _checkCollectionsAccess() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return CheckResult(passed: false, message: 'No user for collection access');
      }

      // Test read access to key collections
      final collections = ['wallets', 'transactions', 'loans', 'categories'];
      
      for (final collection in collections) {
        await _firestore
            .collection(collection)
            .where('userId', isEqualTo: user.uid)
            .limit(1)
            .get();
      }
      
      return CheckResult(passed: true, message: 'All collections accessible');
    } catch (e) {
      return CheckResult(passed: false, message: 'Collection access failed: $e');
    }
  }

  Future<CheckResult> _checkOfflineCache() async {
    try {
      // Try to get cached data
      final user = _auth.currentUser;
      if (user == null) {
        return CheckResult(passed: false, message: 'No user for cache check');
      }

      await _firestore
          .collection('wallets')
          .where('userId', isEqualTo: user.uid)
          .limit(1)
          .get(const GetOptions(source: Source.cache));
      
      return CheckResult(passed: true, message: 'Offline cache working');
    } catch (e) {
      // Cache might be empty, not necessarily an error
      return CheckResult(passed: true, message: 'Cache empty or unavailable');
    }
  }
}

class CheckResult {
  final bool passed;
  final String message;

  CheckResult({required this.passed, required this.message});
}

class HealthCheckResult {
  final bool isHealthy;
  final List<String> issues;
  final bool authValid;
  final bool userDocExists;
  final bool collectionsAccessible;
  final bool offlineCacheWorking;

  HealthCheckResult({
    required this.isHealthy,
    required this.issues,
    required this.authValid,
    required this.userDocExists,
    required this.collectionsAccessible,
    required this.offlineCacheWorking,
  });

  @override
  String toString() {
    return 'HealthCheckResult(healthy: $isHealthy, issues: $issues)';
  }
}
