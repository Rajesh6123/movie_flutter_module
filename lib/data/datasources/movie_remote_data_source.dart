import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/error/exceptions.dart';
import '../models/movie_model.dart';

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getPopularMovies();
  Future<String> getMovieTrailerKey(int movieId);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final Dio dio;

  MovieRemoteDataSourceImpl(this.dio);

  @override
  Future<List<MovieModel>> getPopularMovies() async {
    try {
      final response = await dio.get(
        ApiConstants.popularMoviesEndpoint,
        queryParameters: {
          'api_key': ApiConstants.tmdbApiKey,
          'language': 'en-US',
          'page': 1,
        },
      );

      if (response.statusCode == 200) {
        final results = response.data['results'] as List<dynamic>;
        return results
            .map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      throw ServerException('Unexpected status code: ${response.statusCode}');
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch movies');
    }
  }

  @override
  Future<String> getMovieTrailerKey(int movieId) async {
    try {
      final response = await dio.get(
        '${ApiConstants.videosEndpoint}/$movieId/videos',
        queryParameters: {
          'api_key': ApiConstants.tmdbApiKey,
          'language': 'en-US',
        },
      );

      if (response.statusCode == 200) {
        final videos = (response.data['results'] as List)
    .cast<Map<String, dynamic>>();

Map<String, dynamic>? selected;

// Trailer
selected = videos.cast<Map<String, dynamic>?>().firstWhere(
  (v) => v!['site'] == 'YouTube' && v['type'] == 'Trailer',
  orElse: () => null,
);

// Teaser
selected ??= videos.cast<Map<String, dynamic>?>().firstWhere(
  (v) => v!['site'] == 'YouTube' && v['type'] == 'Teaser',
  orElse: () => null,
);

// Featurette
selected ??= videos.cast<Map<String, dynamic>?>().firstWhere(
  (v) => v!['site'] == 'YouTube' && v['type'] == 'Featurette',
  orElse: () => null,
);

if (selected == null) {
  throw ServerException('No playable video found');
}

return selected['key'];
        // final results = response.data['results'] as List<dynamic>;
        // final trailer = results.firstWhere(
        //   (v) => v['type'] == 'Trailer' && v['site'] == 'YouTube',
        //   orElse: () => null,
        // );
        // if (trailer == null) {
        //   throw ServerException('No trailer found for this movie');
        // }
        // return trailer['key'] as String;
      }
      throw ServerException('Unexpected status code: ${response.statusCode}');
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch trailer');
    }
  }
}
