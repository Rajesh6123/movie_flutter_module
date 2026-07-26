import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection_container.dart' as di;
import 'presentation/bloc/movie_bloc.dart';
import 'presentation/bloc/movie_event.dart';
import 'presentation/pages/movie_list_page.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initDependencies();
  runApp(const MovieModuleApp());
}

class MovieModuleApp extends StatelessWidget {
  const MovieModuleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Module',
      home: BlocProvider(
        create: (_) => di.sl<MovieBloc>()..add(const FetchMoviesEvent()),
        child: const MovieListPage(),
      ),
    );
  }
}
