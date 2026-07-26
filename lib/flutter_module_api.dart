import 'package:flutter/services.dart';

/// Bridge between the Flutter module and the native host apps.
///
/// The native side (Android/iOS) registers a listener on this channel.
/// When the user selects a movie and its trailer key is resolved, we invoke
/// `showTrailer` so the *native* app can push its own native trailer screen,
/// per the task requirement ("navigate back to native app to display the
/// trailer on a native screen").
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
