import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

/// Network info interface for checking internet connectivity
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

/// Implementation of NetworkInfo using internet_connection_checker_plus
class NetworkInfoImpl implements NetworkInfo {
  final InternetConnection connectionChecker;

  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected => connectionChecker.hasInternetAccess;
}
