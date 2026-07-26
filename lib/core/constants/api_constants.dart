class ApiConstants {
  ApiConstants._();

  // Generate your own key at https://www.themoviedb.org/settings/api
  // Never commit real keys to a public repo - inject via --dart-define instead:
  //   flutter build apk --dart-define=TMDB_API_KEY=your_real_key
  static const String tmdbApiKey = String.fromEnvironment(
    'TMDB_API_KEY',
    defaultValue: 'YOUR_TMDB_API_KEY_HERE',
  );

  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  static const String popularMoviesEndpoint = '/movie/popular';
  static const String videosEndpoint = '/movie'; // /{movie_id}/videos

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
