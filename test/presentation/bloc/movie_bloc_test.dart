import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_flutter_module/core/error/failures.dart';
import 'package:movie_flutter_module/core/usecase/usecase.dart';
import 'package:movie_flutter_module/domain/entities/movie.dart';
import 'package:movie_flutter_module/domain/usecases/get_movie_trailer.dart';
import 'package:movie_flutter_module/domain/usecases/get_movies.dart';
import 'package:movie_flutter_module/presentation/bloc/movie_bloc.dart';
import 'package:movie_flutter_module/presentation/bloc/movie_event.dart';
import 'package:movie_flutter_module/presentation/bloc/movie_state.dart';

class MockGetMovies extends Mock implements GetMovies {}

class MockGetMovieTrailer extends Mock implements GetMovieTrailer {}

void main() {
  late MockGetMovies getMovies;
  late MockGetMovieTrailer getMovieTrailer;
  late MovieBloc bloc;

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(const TrailerParams(0));
  });

  setUp(() {
    getMovies = MockGetMovies();
    getMovieTrailer = MockGetMovieTrailer();
    bloc = MovieBloc(getMovies: getMovies, getMovieTrailer: getMovieTrailer);
  });

  tearDown(() => bloc.close());

  const tMovies = [
    Movie(
      id: 1,
      title: 'Inception',
      overview: 'Dreams',
      posterPath: '/a.jpg',
      releaseDate: '2010',
      voteAverage: 8.3,
    ),
  ];

  test('initial state is MovieInitial', () {
    expect(bloc.state, const MovieInitial());
  });

  group('FetchMoviesEvent', () {
    blocTest<MovieBloc, MovieState>(
      'emits [MovieLoading, MovieLoaded] when fetching succeeds',
      build: () {
        when(() => getMovies(any())).thenAnswer((_) async => const Right(tMovies));
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchMoviesEvent()),
      expect: () => const [
        MovieLoading(),
        MovieLoaded(tMovies),
      ],
    );

    blocTest<MovieBloc, MovieState>(
      'emits [MovieLoading, MovieError] when fetching fails',
      build: () {
        when(() => getMovies(any()))
            .thenAnswer((_) async => const Left(ServerFailure('fail')));
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchMoviesEvent()),
      expect: () => const [
        MovieLoading(),
        MovieError('fail'),
      ],
    );
  });

  group('MovieSelectedEvent', () {
    blocTest<MovieBloc, MovieState>(
      'emits [MovieTrailerReady, MovieLoaded] when trailer lookup succeeds',
      build: () {
        when(() => getMovieTrailer(any()))
            .thenAnswer((_) async => const Right('xyz789'));
        return bloc;
      },
      act: (bloc) => bloc.add(const MovieSelectedEvent(1)),
      expect: () => const [
        MovieTrailerReady(movieId: 1, trailerKey: 'xyz789'),
        MovieLoaded([]),
      ],
    );

    blocTest<MovieBloc, MovieState>(
      'emits [MovieTrailerError, MovieLoaded] when trailer lookup fails',
      build: () {
        when(() => getMovieTrailer(any()))
            .thenAnswer((_) async => const Left(ServerFailure('no trailer')));
        return bloc;
      },
      act: (bloc) => bloc.add(const MovieSelectedEvent(1)),
      expect: () => const [
        MovieTrailerError('no trailer'),
        MovieLoaded([]),
      ],
    );
  });
}
