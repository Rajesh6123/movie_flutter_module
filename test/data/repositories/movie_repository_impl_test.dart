import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_flutter_module/core/error/exceptions.dart';
import 'package:movie_flutter_module/core/error/failures.dart';
import 'package:movie_flutter_module/core/network/network_info.dart';
import 'package:movie_flutter_module/data/datasources/movie_remote_data_source.dart';
import 'package:movie_flutter_module/data/models/movie_model.dart';
import 'package:movie_flutter_module/data/repositories/movie_repository_impl.dart';

class MockRemoteDataSource extends Mock implements MovieRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late MovieRepositoryImpl repository;
  late MockRemoteDataSource remoteDataSource;
  late MockNetworkInfo networkInfo;

  setUp(() {
    remoteDataSource = MockRemoteDataSource();
    networkInfo = MockNetworkInfo();
    repository = MovieRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
  });

  const tMovieModels = [
    MovieModel(id: 1, title: 'Inception', overview: 'Dreams', posterPath: '/a.jpg'),
  ];

  group('getPopularMovies', () {
    test('should return NetworkFailure when device is offline', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => false);

      final result = await repository.getPopularMovies();

      expect(result, const Left(NetworkFailure()));
      verifyZeroInteractions(remoteDataSource);
    });

    test('should return movies when the remote call succeeds', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(() => remoteDataSource.getPopularMovies())
          .thenAnswer((_) async => tMovieModels);

      final result = await repository.getPopularMovies();

      expect(result, const Right(tMovieModels));
    });

    test('should return ServerFailure when the remote call throws', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(() => remoteDataSource.getPopularMovies())
          .thenThrow(ServerException('down'));

      final result = await repository.getPopularMovies();

      expect(result, const Left(ServerFailure('down')));
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
