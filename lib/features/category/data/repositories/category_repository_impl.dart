import 'package:dartz/dartz.dart';
import 'package:finlisty/core/error/failures.dart';
import 'package:finlisty/core/network/network_info.dart';
import 'package:finlisty/features/category/data/datasources/category_remote_data_source.dart';
import 'package:finlisty/features/category/data/models/category_model.dart';
import 'package:finlisty/features/category/domain/entities/category.dart';
import 'package:finlisty/features/category/domain/repositories/category_repository.dart';

/// Implementation of CategoryRepository
class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  CategoryRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    if (await networkInfo.isConnected) {
      try {
        final categories = await remoteDataSource.getCategories();
        return Right(categories.map((c) => c.toEntity()).toList());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Category>> getCategoryById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final category = await remoteDataSource.getCategoryById(id);
        if (category == null) {
          return Left(NotFoundFailure('Category not found'));
        }
        return Right(category.toEntity());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> addCategory(Category category) async {
    if (await networkInfo.isConnected) {
      try {
        final categoryModel = CategoryModel.fromEntity(category);
        await remoteDataSource.addCategory(categoryModel);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> updateCategory(Category category) async {
    if (await networkInfo.isConnected) {
      try {
        final categoryModel = CategoryModel.fromEntity(category);
        await remoteDataSource.updateCategory(categoryModel);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteCategory(id);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> initializeDefaultCategories() async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.initializeDefaultCategories();
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Stream<List<Category>> watchCategories() {
    return remoteDataSource
        .watchCategories()
        .map((categories) => categories.map((c) => c.toEntity()).toList());
  }
}
