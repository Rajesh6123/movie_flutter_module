import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie_remote_data_source.dart';
import '../datasources/movie_local_data_source.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;
  final MovieLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  MovieRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Movie>>> getPopularMovies() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteMovies = await remoteDataSource.getPopularMovies();
        await localDataSource.cachePopularMovies(remoteMovies);
        return Right(remoteMovies);
      } on ServerException catch (e) {
        try {
          final localMovies = await localDataSource.getLastPopularMovies();
          return Right(localMovies);
        } catch (_) {
          return Left(ServerFailure(e.message));
        }
      }
    } else {
      try {
        final localMovies = await localDataSource.getLastPopularMovies();
        return Right(localMovies);
      } on CacheException {
        return const Left(NetworkFailure('No internet connection.'));
      }
    }
  }

  @override
  Future<Either<Failure, String>> getMovieTrailerKey(int movieId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final key = await remoteDataSource.getMovieTrailerKey(movieId);
      return Right(key);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
