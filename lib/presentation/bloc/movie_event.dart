import 'package:equatable/equatable.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object?> get props => [];
}

class FetchMoviesEvent extends MovieEvent {
  const FetchMoviesEvent();
}


class MovieSelectedEvent extends MovieEvent {
  final int movieId;
  const MovieSelectedEvent(this.movieId);

  @override
  List<Object?> get props => [movieId];
}
