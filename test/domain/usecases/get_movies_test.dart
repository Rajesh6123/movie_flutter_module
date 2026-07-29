import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_flutter_module/core/error/failures.dart';
import 'package:movie_flutter_module/core/usecase/usecase.dart';
import 'package:movie_flutter_module/domain/entities/movie.dart';
import 'package:movie_flutter_module/domain/repositories/movie_repository.dart';
import 'package:movie_flutter_module/domain/usecases/get_movies.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  late GetMovies usecase;
  late MockMovieRepository repository;

  setUp(() {
    repository = MockMovieRepository();
    usecase = GetMovies(repository);
  });

  const tMovies = [
    Movie(id: 1, title: 'Inception', overview: 'Dreams', posterPath: '/a.jpg', releaseDate: '2010', voteAverage: 8.3),
    Movie(id: 2, title: 'Interstellar', overview: 'Space', posterPath: '/b.jpg', releaseDate: '2014', voteAverage: 8.6),
  ];

  test('should get list of movies from the repository', () async {
    // arrange
    when(() => repository.getPopularMovies())
        .thenAnswer((_) async => const Right(tMovies));

    // act
    final result = await usecase(const NoParams());

    // assert
    expect(result, const Right(tMovies));
    verify(() => repository.getPopularMovies()).called(1);
    verifyNoMoreInteractions(repository);
  });

  test('should return a ServerFailure when the repository call fails',
      () async {
    // arrange
    when(() => repository.getPopularMovies())
        .thenAnswer((_) async => const Left(ServerFailure('boom')));

    // act
    final result = await usecase(const NoParams());

    // assert
    expect(result, const Left(ServerFailure('boom')));
  });
}
