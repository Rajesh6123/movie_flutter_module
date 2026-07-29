import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/error/exceptions.dart';
import '../models/movie_model.dart';

abstract class MovieLocalDataSource {
  Future<List<MovieModel>> getLastPopularMovies();
  Future<void> cachePopularMovies(List<MovieModel> moviesToCache);
}

const cachedPopularMoviesKey = 'CACHED_POPULAR_MOVIES';

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  final SharedPreferences sharedPreferences;

  MovieLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<MovieModel>> getLastPopularMovies() {
    final jsonString = sharedPreferences.getString(cachedPopularMoviesKey);
    if (jsonString != null) {
      try {
        final List<dynamic> decoded = json.decode(jsonString);
        return Future.value(
          decoded.map((e) => MovieModel.fromJson(e as Map<String, dynamic>)).toList(),
        );
      } catch (_) {
        throw CacheException();
      }
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cachePopularMovies(List<MovieModel> moviesToCache) {
    final List<Map<String, dynamic>> jsonList =
        moviesToCache.map((movie) => movie.toJson()).toList();
    return sharedPreferences.setString(
      cachedPopularMoviesKey,
      json.encode(jsonList),
    );
  }
}
