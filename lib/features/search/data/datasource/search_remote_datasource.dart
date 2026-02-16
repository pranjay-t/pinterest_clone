import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinterest_clone/core/network/dio_service.dart';
import 'package:pinterest_clone/core/utils/app_logger.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_photo_model.dart';

final searchRemoteDataSourceProvider = Provider<SearchRemoteDataSource>((ref) {
  final dioService = ref.read(dioServiceProvider);
  return SearchRemoteDataSourceImpl(dioService.dio);
});

abstract class SearchRemoteDataSource {
  Future<List<PexelsPhoto>> fetchPhotos({required String query, required int page, int perPage = 20});
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final Dio _dio;

  SearchRemoteDataSourceImpl(this._dio);

  @override
  Future<List<PexelsPhoto>> fetchPhotos({required String query, required int page, int perPage = 20}) async {
    try {
      AppLogger.logInfo('Fetching search photos: query=$query, page=$page');
      
      final response = await _dio.get(
        'search',
        queryParameters: {
          'query': query,
          'page': page,
          'per_page': perPage,
        },
      );

      final pexelsResponse = PexelsResponse.fromJson(response.data);
      AppLogger.logDebug('Fetched ${pexelsResponse.photos.length} photos for query: $query');
      
      return pexelsResponse.photos;
    } catch (e, stackTrace) {
      AppLogger.logError('Error fetching search photos', e, stackTrace);
      rethrow;
    }
  }
}
