import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinterest_clone/core/network/dio_service.dart';
import 'package:pinterest_clone/core/utils/app_logger.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_photo_model.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_video_model.dart';

final homeRemoteDataSourceProvider = Provider<HomeRemoteDataSource>((ref) {
  final dioService = ref.read(dioServiceProvider);
  return HomeRemoteDataSourceImpl(dioService.dio);
});

abstract class HomeRemoteDataSource {
  Future<List<PexelsPhoto>> fetchCuratedPhotos({required int page, int perPage = 15});
  Future<List<PexelsVideo>> searchVideos({required String query, required int page, int perPage = 15});
  Future<List<PexelsVideo>> fetchPopularVideos({required int page, int perPage = 15});
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio _dio;

  HomeRemoteDataSourceImpl(this._dio);

  @override
  Future<List<PexelsPhoto>> fetchCuratedPhotos({required int page, int perPage = 15}) async {
    try {
      AppLogger.logInfo('Fetching curated photos: page=$page, perPage=$perPage');
      
      final response = await _dio.get(
        'curated',
        queryParameters: {
          'page': page,
          'per_page': perPage,
        },
      );

      AppLogger.logInfo('Successfully fetched photos from API');
      
      final pexelsResponse = PexelsResponse.fromJson(response.data);
      
      AppLogger.logDebug('Parsed ${pexelsResponse.photos.length} photos');
      
      return pexelsResponse.photos;
    } on DioException catch (e) {
      AppLogger.logError('DioError fetching curated photos: ${e.message}', e);
      rethrow;
    } catch (e, stackTrace) {
      AppLogger.logError('Unexpected error fetching curated photos', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<List<PexelsVideo>> searchVideos({required String query, required int page, int perPage = 15}) async {
    try {
      AppLogger.logInfo('Searching videos: query=$query, page=$page, perPage=$perPage');
      
      final response = await _dio.get(
        'videos/search',
        queryParameters: {
          'query': query,
          'page': page,
          'per_page': perPage,
        },
      );

      final pexelsResponse = PexelsVideoResponse.fromJson(response.data);
      return pexelsResponse.videos;
    } on DioException catch (e) {
      AppLogger.logError('DioError searching videos: ${e.message}', e);
      rethrow;
    } catch (e, stackTrace) {
      AppLogger.logError('Unexpected error searching videos', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<List<PexelsVideo>> fetchPopularVideos({required int page, int perPage = 15}) async {
    try {
      AppLogger.logInfo('Fetching popular videos: page=$page, perPage=$perPage');
      
      final response = await _dio.get(
        'videos/popular',
        queryParameters: {
          'page': page,
          'per_page': perPage,
        },
      );

      final pexelsResponse = PexelsVideoResponse.fromJson(response.data);
      return pexelsResponse.videos;
    } on DioException catch (e) {
      AppLogger.logError('DioError fetching popular videos: ${e.message}', e);
      rethrow;
    } catch (e, stackTrace) {
      AppLogger.logError('Unexpected error fetching popular videos', e, stackTrace);
      rethrow;
    }
  }
}