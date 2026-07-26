import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../core/error/failures.dart';
import '../../core/usecase/usecase.dart';
import '../repositories/movie_repository.dart';

class GetMovieTrailer implements UseCase<String, TrailerParams> {
  final MovieRepository repository;

  GetMovieTrailer(this.repository);

  @override
  Future<Either<Failure, String>> call(TrailerParams params) async {
    return repository.getMovieTrailerKey(params.movieId);
  }
}

class TrailerParams extends Equatable {
  final int movieId;
  const TrailerParams(this.movieId);

  @override
  List<Object?> get props => [movieId];
}
