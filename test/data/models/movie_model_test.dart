import 'package:flutter_test/flutter_test.dart';
import 'package:movie_flutter_module/data/models/movie_model.dart';
import 'package:movie_flutter_module/domain/entities/movie.dart';

void main() {
  const tMovieModel = MovieModel(
    id: 27205,
    title: 'Inception',
    overview: 'A thief who steals corporate secrets...',
    posterPath: '/9gk7adHYeDvHkCSEqAvQNLV5Uge.jpg',
    releaseDate: '2010-07-15',
    voteAverage: 8.3,
  );

  test('should be a subclass of the Movie entity', () {
    expect(tMovieModel, isA<Movie>());
  });

  group('fromJson', () {
    test('should return a valid model from TMDB-shaped JSON', () {
      final json = {
        'id': 27205,
        'title': 'Inception',
        'overview': 'A thief who steals corporate secrets...',
        'poster_path': '/9gk7adHYeDvHkCSEqAvQNLV5Uge.jpg',
        'release_date': '2010-07-15',
        'vote_average': 8.3,
      };

      final result = MovieModel.fromJson(json);

      expect(result, tMovieModel);
    });

    test('should default missing fields gracefully', () {
      final result = MovieModel.fromJson(const {'id': 5});

      expect(result.id, 5);
      expect(result.title, 'Untitled');
      expect(result.overview, '');
      expect(result.posterPath, '');
      expect(result.releaseDate, '');
      expect(result.voteAverage, 0.0);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data', () {
      final result = tMovieModel.toJson();

      expect(result, {
        'id': 27205,
        'title': 'Inception',
        'overview': 'A thief who steals corporate secrets...',
        'poster_path': '/9gk7adHYeDvHkCSEqAvQNLV5Uge.jpg',
        'release_date': '2010-07-15',
        'vote_average': 8.3,
      });
    });
  });
}
