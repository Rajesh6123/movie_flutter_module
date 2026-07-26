import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../flutter_module_api.dart';
import '../bloc/movie_bloc.dart';
import '../bloc/movie_event.dart';
import '../bloc/movie_state.dart';
import '../widgets/movie_card.dart';

class MovieListPage extends StatelessWidget {
  const MovieListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Popular Movies')),
      body: BlocConsumer<MovieBloc, MovieState>(
        listener: (context, state) {
          if (state is MovieTrailerReady) {
           
            FlutterModuleApi.showNativeTrailer(
              movieId: state.movieId,
              trailerKey: state.trailerKey,
            );
          } else if (state is MovieTrailerError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is MovieInitial) {
            return const SizedBox.shrink();
          }
          if (state is MovieLoading) {
            return const Center(
              key: Key('loading_indicator'),
              child: CircularProgressIndicator(),
            );
          }
          if (state is MovieError) {
            return Center(
              key: const Key('error_view'),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.message),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<MovieBloc>().add(const FetchMoviesEvent()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (state is MovieLoaded) {
            return ListView.builder(
              key: const Key('movie_list_view'),
              itemCount: state.movies.length,
              itemBuilder: (context, index) {
                final movie = state.movies[index];
                return MovieCard(
                  movie: movie,
                  onTap: () => context
                      .read<MovieBloc>()
                      .add(MovieSelectedEvent(movie.id)),
                );
              },
            );
          }
          
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
