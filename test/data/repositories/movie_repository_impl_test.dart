import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_flutter_module/core/error/exceptions.dart';
import 'package:movie_flutter_module/core/error/failures.dart';
import 'package:movie_flutter_module/core/network/network_info.dart';
import 'package:movie_flutter_module/data/datasources/movie_remote_data_source.dart';
import 'package:movie_flutter_module/data/models/movie_model.dart';
import 'package:movie_flutter_module/data/repositories/movie_repository_impl.dart';

import 'package:movie_flutter_module/data/datasources/movie_local_data_source.dart';

class MockRemoteDataSource extends Mock implements MovieRemoteDataSource {}

class MockLocalDataSource extends Mock implements MovieLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late MovieRepositoryImpl repository;
  late MockRemoteDataSource remoteDataSource;
  late MockLocalDataSource localDataSource;
  late MockNetworkInfo networkInfo;

  setUp(() {
    remoteDataSource = MockRemoteDataSource();
    localDataSource = MockLocalDataSource();
    networkInfo = MockNetworkInfo();
    repository = MovieRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: networkInfo,
    );
  });

  const tMovieModels = [
    MovieModel(
      id: 1,
      title: 'Inception',
      overview: 'Dreams',
      posterPath: '/a.jpg',
      releaseDate: '2010',
      voteAverage: 8.3,
    ),
  ];

  group('getPopularMovies', () {
    test('should return local movies when device is offline and cached data exists', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => false);
      when(() => localDataSource.getLastPopularMovies()).thenAnswer((_) async => tMovieModels);

      final result = await repository.getPopularMovies();

      expect(result, const Right(tMovieModels));
      verify(() => localDataSource.getLastPopularMovies()).called(1);
      verifyZeroInteractions(remoteDataSource);
    });

    test('should return NetworkFailure when device is offline and no cached data exists', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => false);
      when(() => localDataSource.getLastPopularMovies()).thenThrow(CacheException());

      final result = await repository.getPopularMovies();

      expect(result, const Left(NetworkFailure('No internet connection.')));
      verify(() => localDataSource.getLastPopularMovies()).called(1);
    });

    test('should return remote movies and cache them when the remote call succeeds', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(() => remoteDataSource.getPopularMovies()).thenAnswer((_) async => tMovieModels);
      when(() => localDataSource.cachePopularMovies(tMovieModels)).thenAnswer((_) async => {});

      final result = await repository.getPopularMovies();

      expect(result, const Right(tMovieModels));
      verify(() => remoteDataSource.getPopularMovies()).called(1);
      verify(() => localDataSource.cachePopularMovies(tMovieModels)).called(1);
    });

    test('should return cached movies when remote call fails but cached data exists', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(() => remoteDataSource.getPopularMovies()).thenThrow(ServerException('down'));
      when(() => localDataSource.getLastPopularMovies()).thenAnswer((_) async => tMovieModels);

      final result = await repository.getPopularMovies();

      expect(result, const Right(tMovieModels));
      verify(() => remoteDataSource.getPopularMovies()).called(1);
      verify(() => localDataSource.getLastPopularMovies()).called(1);
    });
  });

  group('getMovieTrailerKey', () {
    test('should return the trailer key on success', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(() => remoteDataSource.getMovieTrailerKey(1))
          .thenAnswer((_) async => 'abc123');

      final result = await repository.getMovieTrailerKey(1);

      expect(result, const Right('abc123'));
    });

    test('should return ServerFailure when no trailer is found', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(() => remoteDataSource.getMovieTrailerKey(1))
          .thenThrow(ServerException('No trailer found for this movie'));

      final result = await repository.getMovieTrailerKey(1);

      expect(result, const Left(ServerFailure('No trailer found for this movie')));
    });
  });
}
