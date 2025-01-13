import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_install_referrer/flutter_install_referrer.dart';

import 'flutter_install_referrer_platform_interface.dart';

/// An implementation of [FlutterInstallReferrerPlatform] that uses method channels.
class MethodChannelFlutterInstallReferrer extends FlutterInstallReferrerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_install_referrer');

  @override
  Future<ReferrerDetails?> getInstallReferrer() async {
    final referrerDetails = await methodChannel.invokeMapMethod<String, dynamic>('getInstallReferrer');
    if (referrerDetails != null) {
      return ReferrerDetails.fromMap(referrerDetails);
    }

    return null;
  }
}
