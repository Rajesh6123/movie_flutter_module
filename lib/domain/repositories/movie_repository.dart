import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/movie.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<Movie>>> getPopularMovies();

  /// Returns a YouTube video key for the trailer of [movieId], if one exists.
  Future<Either<Failure, String>> getMovieTrailerKey(int movieId);
}
