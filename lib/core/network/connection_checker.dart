import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract interface class IConnectionChecker {
  Future<bool> get isConnected;
}

class ConnectionChecker implements IConnectionChecker {
  final InternetConnection internetConnection;

  ConnectionChecker(this.internetConnection);

  @override
  // TODO: implement isConnected
  Future<bool> get isConnected async =>
      await internetConnection.hasInternetAccess;
}
