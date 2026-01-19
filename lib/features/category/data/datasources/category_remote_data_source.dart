import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:finlisty/features/category/data/models/category_model.dart';

/// Remote data source for Category operations using Firestore
abstract class CategoryRemoteDataSource {
  /// Get all categories for the current user
  Future<List<CategoryModel>> getCategories();

  /// Get a specific category by ID
  Future<CategoryModel?> getCategoryById(String id);

  /// Add a new category
  Future<void> addCategory(CategoryModel category);

  /// Update an existing category
  Future<void> updateCategory(CategoryModel category);

  /// Delete a category
  Future<void> deleteCategory(String id);

  /// Initialize default categories for a new user
  Future<void> initializeDefaultCategories();

  /// Stream of categories for real-time updates
  Stream<List<CategoryModel>> watchCategories();
}

/// Implementation of CategoryRemoteDataSource
class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  CategoryRemoteDataSourceImpl({
    required this.firestore,
    required this.auth,
  });

  String get _userId => auth.currentUser?.uid ?? '';

  CollectionReference get _categoriesCollection =>
      firestore.collection('users').doc(_userId).collection('categories');

  @override
  Future<List<CategoryModel>> getCategories() async {
    final snapshot = await _categoriesCollection
        .where('isActive', isEqualTo: true)
        .orderBy('sortOrder')
        .get();

    return snapshot.docs
        .map((doc) => CategoryModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<CategoryModel?> getCategoryById(String id) async {
    final doc = await _categoriesCollection.doc(id).get();
    if (!doc.exists) return null;
    return CategoryModel.fromJson(doc.data() as Map<String, dynamic>);
  }

  @override
  Future<void> addCategory(CategoryModel category) async {
    await _categoriesCollection.doc(category.id).set(category.toJson());
  }

  @override
  Future<void> updateCategory(CategoryModel category) async {
    await _categoriesCollection.doc(category.id).update(category.toJson());
  }

  @override
  Future<void> deleteCategory(String id) async {
    // Soft delete - mark as inactive
    await _categoriesCollection.doc(id).update({'isActive': false});
  }

  @override
  Future<void> initializeDefaultCategories() async {
    final defaultCategories = CategoryModel.getDefaultCategories();
    final batch = firestore.batch();

    for (final category in defaultCategories) {
      final docRef = _categoriesCollection.doc(category.id);
      batch.set(docRef, category.toJson());
    }

    await batch.commit();
  }

  @override
  Stream<List<CategoryModel>> watchCategories() {
    return _categoriesCollection
        .where('isActive', isEqualTo: true)
        .orderBy('sortOrder')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CategoryModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList());
  }
}
