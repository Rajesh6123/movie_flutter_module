import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_flutter_module/domain/entities/movie.dart';
import 'package:movie_flutter_module/presentation/bloc/movie_bloc.dart';
import 'package:movie_flutter_module/presentation/bloc/movie_event.dart';
import 'package:movie_flutter_module/presentation/bloc/movie_state.dart';
import 'package:movie_flutter_module/presentation/pages/movie_list_page.dart';

class MockMovieBloc extends MockBloc<MovieEvent, MovieState>
    implements MovieBloc {}

void main() {
  late MockMovieBloc bloc;

  setUpAll(() {
    registerFallbackValue(const FetchMoviesEvent());
  });

  setUp(() {
    bloc = MockMovieBloc();
  });

  Widget wrap() => MaterialApp(
        home: BlocProvider<MovieBloc>.value(
          value: bloc,
          child: const MovieListPage(),
        ),
      );

  testWidgets('shows a loading indicator while movies are loading',
      (tester) async {
    when(() => bloc.state).thenReturn(const MovieLoading());

    await tester.pumpWidget(wrap());

    expect(find.byKey(const Key('loading_indicator')), findsOneWidget);
  });

  testWidgets('shows the list of movies once loaded', (tester) async {
    when(() => bloc.state).thenReturn(const MovieLoaded([
      Movie(id: 1, title: 'Dune', overview: 'Desert planet.', posterPath: ''),
      Movie(id: 2, title: 'Arrival', overview: 'Aliens land.', posterPath: ''),
    ]));

    await tester.pumpWidget(wrap());

    expect(find.byKey(const Key('movie_list_view')), findsOneWidget);
    expect(find.text('Dune'), findsOneWidget);
    expect(find.text('Arrival'), findsOneWidget);
  });

  testWidgets('shows an error view with a retry button on failure',
      (tester) async {
    when(() => bloc.state).thenReturn(const MovieError('Server error'));

    await tester.pumpWidget(wrap());

    expect(find.byKey(const Key('error_view')), findsOneWidget);
    expect(find.text('Server error'), findsOneWidget);

    await tester.tap(find.text('Retry'));
    await tester.pump();

    verify(() => bloc.add(const FetchMoviesEvent())).called(1);
  });

  testWidgets('tapping a movie card dispatches MovieSelectedEvent',
      (tester) async {
    when(() => bloc.state).thenReturn(const MovieLoaded([
      Movie(id: 7, title: 'Tenet', overview: 'Time inverts.', posterPath: ''),
    ]));

    await tester.pumpWidget(wrap());
    await tester.tap(find.byKey(const Key('movie_card_7')));
    await tester.pump();

    verify(() => bloc.add(const MovieSelectedEvent(7))).called(1);
  });
}
