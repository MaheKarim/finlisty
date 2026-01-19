import 'package:dartz/dartz.dart';
import 'package:finlisty/core/error/failures.dart';
import 'package:finlisty/features/category/domain/entities/category.dart';

/// Repository interface for Category operations
abstract class CategoryRepository {
  /// Get all categories for the current user
  Future<Either<Failure, List<Category>>> getCategories();

  /// Get a specific category by ID
  Future<Either<Failure, Category>> getCategoryById(String id);

  /// Add a new category
  Future<Either<Failure, void>> addCategory(Category category);

  /// Update an existing category
  Future<Either<Failure, void>> updateCategory(Category category);

  /// Delete a category
  Future<Either<Failure, void>> deleteCategory(String id);

  /// Initialize default categories for a new user
  Future<Either<Failure, void>> initializeDefaultCategories();

  /// Stream of categories for real-time updates
  Stream<List<Category>> watchCategories();
}
