import 'package:equatable/equatable.dart';
import '../../domain/entities/movie.dart';

abstract class MovieState extends Equatable {
  const MovieState();

  @override
  List<Object?> get props => [];
}

class MovieInitial extends MovieState {
  const MovieInitial();
}

class MovieLoading extends MovieState {
  const MovieLoading();
}

class MovieLoaded extends MovieState {
  final List<Movie> movies;
  const MovieLoaded(this.movies);

  @override
  List<Object?> get props => [movies];
}

class MovieError extends MovieState {
  final String message;
  const MovieError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Emitted once a trailer key has been resolved for a selected movie so the
/// UI layer can hand control back to the native host via the MethodChannel.
class MovieTrailerReady extends MovieState {
  final int movieId;
  final String trailerKey;
  const MovieTrailerReady({required this.movieId, required this.trailerKey});

  @override
  List<Object?> get props => [movieId, trailerKey];
}

class MovieTrailerError extends MovieState {
  final String message;
  const MovieTrailerError(this.message);

  @override
  List<Object?> get props => [message];
}
