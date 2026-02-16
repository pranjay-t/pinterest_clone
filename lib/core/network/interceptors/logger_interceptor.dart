import 'package:dio/dio.dart';
import 'package:pinterest_clone/core/utils/app_logger.dart';

class LoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.logInfo('🌐 REQUEST [${options.method}] => PATH: ${options.path}');
    AppLogger.logDebug('Query Params: ${options.queryParameters}');
    if (options.data != null) {
      AppLogger.logDebug('Request Body: ${options.data}');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.logInfo('✅ RESPONSE [${response.statusCode}] => PATH: ${response.requestOptions.path}');
    AppLogger.logDebug('Response Data: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.logError('❌ ERROR [${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    AppLogger.logError('Error Message: ${err.message}');
    if (err.response != null) {
      AppLogger.logError('Error Response: ${err.response?.data}');
    }
    super.onError(err, handler);
  }
}
