class ServerException implements Exception {
  final String message;
  final int? statusCode;
  ServerException({this.message = 'Server Error', this.statusCode});
}

class CacheException implements Exception {
  final String message;
  CacheException({this.message = 'Cache Error'});
}

class NetworkException implements Exception {
  final String message;
  NetworkException({this.message = 'No Internet Connection'});
}
