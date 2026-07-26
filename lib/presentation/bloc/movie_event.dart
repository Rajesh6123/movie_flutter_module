import 'package:equatable/equatable.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object?> get props => [];
}

/// Fired when the movie list screen is first opened.
class FetchMoviesEvent extends MovieEvent {
  const FetchMoviesEvent();
}

/// Fired when the user taps a movie card.
class MovieSelectedEvent extends MovieEvent {
  final int movieId;
  const MovieSelectedEvent(this.movieId);

  @override
  List<Object?> get props => [movieId];
}
