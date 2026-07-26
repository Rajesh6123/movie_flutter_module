import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/usecase/usecase.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_movie_trailer.dart';
import '../../domain/usecases/get_movies.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final GetMovies getMovies;
  final GetMovieTrailer getMovieTrailer;

  /// Cached so the UI can fall back to the list after a trailer
  /// state (success or error) has been consumed by the listener.
  List<Movie> _lastLoadedMovies = const [];

  MovieBloc({
    required this.getMovies,
    required this.getMovieTrailer,
  }) : super(const MovieInitial()) {
    on<FetchMoviesEvent>(_onFetchMovies);
    on<MovieSelectedEvent>(_onMovieSelected);
  }

  Future<void> _onFetchMovies(
    FetchMoviesEvent event,
    Emitter<MovieState> emit,
  ) async {
    emit(const MovieLoading());
    final result = await getMovies(const NoParams());
    result.fold(
      (failure) => emit(MovieError(failure.message)),
      (movies) {
        _lastLoadedMovies = movies;
        emit(MovieLoaded(movies));
      },
    );
  }

  Future<void> _onMovieSelected(
    MovieSelectedEvent event,
    Emitter<MovieState> emit,
  ) async {
    final result = await getMovieTrailer(TrailerParams(event.movieId));
    result.fold(
      (failure) => emit(MovieTrailerError(failure.message)),
      (key) => emit(MovieTrailerReady(movieId: event.movieId, trailerKey: key)),
    );
    // Return to the list view once the trailer hand-off has been emitted.
    emit(MovieLoaded(_lastLoadedMovies));
  }
}
