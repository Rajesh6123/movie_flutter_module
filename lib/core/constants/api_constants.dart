class ApiConstants {
  ApiConstants._();


  static const String tmdbApiKey = String.fromEnvironment(
    'TMDB_API_KEY',
    defaultValue: '6864ec59b7c5d11c69f22f879a00b7b2',
  );

  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  static const String popularMoviesEndpoint = '/movie/popular';
  static const String videosEndpoint = '/movie'; 

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
