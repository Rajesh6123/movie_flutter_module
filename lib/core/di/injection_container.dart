import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../data/datasources/movie_remote_data_source.dart';
import '../../data/repositories/movie_repository_impl.dart';
import '../../domain/repositories/movie_repository.dart';
import '../../domain/usecases/get_movie_trailer.dart';
import '../../domain/usecases/get_movies.dart';
import '../../presentation/bloc/movie_bloc.dart';
import '../constants/api_constants.dart';
import '../network/network_info.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/movie_local_data_source.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerFactory(
    () => MovieBloc(getMovies: sl(), getMovieTrailer: sl()),
  );

 
  sl.registerLazySingleton(() => GetMovies(sl()));
  sl.registerLazySingleton(() => GetMovieTrailer(sl()));

  
  sl.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<MovieLocalDataSource>(
    () => MovieLocalDataSourceImpl(sharedPreferences: sl()),
  );


  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );

  
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
      ),
    );
    return dio;
  });
}
