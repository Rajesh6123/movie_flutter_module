import 'package:flutter/services.dart';


class FlutterModuleApi {
  FlutterModuleApi._();

  static const MethodChannel _channel = MethodChannel('movie_module/navigation');

  static Future<void> showNativeTrailer({
    required int movieId,
    required String trailerKey,
  }) async {
    await _channel.invokeMethod<void>('showTrailer', {
      'movieId': movieId,
      'trailerKey': trailerKey,
    });
  }
}
