import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'core/network/network_info.dart';
import 'features/transaction/data/datasources/transaction_remote_data_source.dart';
import 'features/transaction/data/repositories/transaction_repository_impl.dart';
import 'features/transaction/domain/repositories/transaction_repository.dart';
import 'features/wallet/data/datasources/wallet_remote_data_source.dart';
import 'features/wallet/data/repositories/wallet_repository_impl.dart';
import 'features/wallet/domain/repositories/wallet_repository.dart';

import 'features/loan/data/datasources/loan_remote_data_source.dart';
import 'features/loan/data/repositories/loan_repository_impl.dart';
import 'features/loan/domain/repositories/loan_repository.dart';

import 'features/category/data/datasources/category_remote_data_source.dart';
import 'features/category/data/repositories/category_repository_impl.dart';
import 'features/category/domain/repositories/category_repository.dart';

import 'features/recurring_bill/data/datasources/recurring_bill_remote_data_source.dart';
import 'features/recurring_bill/data/repositories/recurring_bill_repository_impl.dart';
import 'features/recurring_bill/domain/repositories/recurring_bill_repository.dart';
import 'features/auth/data/services/auth_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Services
  sl.registerLazySingleton(() => AuthService());
  // External
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  final connectionChecker = InternetConnection();

  sl.registerLazySingleton(() => firestore);
  sl.registerLazySingleton(() => auth);
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectionChecker),
  );

  // Data Sources
  sl.registerLazySingleton<WalletRemoteDataSource>(
    () => WalletRemoteDataSourceImpl(firestore: sl(), auth: sl()),
  );
  sl.registerLazySingleton<TransactionRemoteDataSource>(
    () => TransactionRemoteDataSourceImpl(firestore: sl(), auth: sl()),
  );
  sl.registerLazySingleton<LoanRemoteDataSource>(
    () => LoanRemoteDataSourceImpl(firestore: sl(), auth: sl()),
  );
  sl.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSourceImpl(firestore: sl(), auth: sl()),
  );
  sl.registerLazySingleton<RecurringBillRemoteDataSource>(
    () => RecurringBillRemoteDataSourceImpl(firestore: sl(), auth: sl()),
  );

  // Repositories
  sl.registerLazySingleton<WalletRepository>(
    () => WalletRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<LoanRepository>(
    () => LoanRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton<RecurringBillRepository>(
    () => RecurringBillRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
}
