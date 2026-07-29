import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_flutter_module/domain/entities/movie.dart';
import 'package:movie_flutter_module/presentation/widgets/movie_card.dart';

void main() {
  const tMovie = Movie(
    id: 42,
    title: 'The Matrix',
    overview: 'A hacker discovers reality is a simulation.',
    posterPath: '', // empty on purpose to avoid a real network call in tests
    releaseDate: '1999-03-31',
    voteAverage: 8.7,
  );

  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('renders the movie title and overview', (tester) async {
    await tester.pumpWidget(
      wrap(MovieCard(movie: tMovie, onTap: () {})),
    );

    expect(find.text('The Matrix'), findsOneWidget);
    expect(
      find.text('A hacker discovers reality is a simulation.'),
      findsOneWidget,
    );
  });

  testWidgets('shows a placeholder movie icon when there is no poster',
      (tester) async {
    await tester.pumpWidget(
      wrap(MovieCard(movie: tMovie, onTap: () {})),
    );

    expect(find.byIcon(Icons.movie), findsOneWidget);
  });

  testWidgets('invokes onTap when the card is tapped', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      wrap(MovieCard(movie: tMovie, onTap: () => tapped = true)),
    );

    await tester.tap(find.byKey(const Key('movie_card_42')));
    await tester.pump();

    expect(tapped, isTrue);
  });
}
