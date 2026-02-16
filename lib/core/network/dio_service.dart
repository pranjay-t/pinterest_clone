import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinterest_clone/core/network/interceptors/logger_interceptor.dart';

final dioServiceProvider = Provider<DioService>((ref) {
  return DioService();
});

class DioService {
  late final Dio _dio;

  DioService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.pexels.com/v1/',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Authorization': dotenv.env['PEXELS_API_KEY'],
        },
      ),
    );

    _dio.interceptors.add(LoggerInterceptor());
  }

  Dio get dio => _dio;
}
