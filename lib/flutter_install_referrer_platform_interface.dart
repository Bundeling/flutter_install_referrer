import 'package:flutter_install_referrer/flutter_install_referrer.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_install_referrer_method_channel.dart';

abstract class FlutterInstallReferrerPlatform extends PlatformInterface {
  /// Constructs a FlutterInstallReferrerPlatform.
  FlutterInstallReferrerPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterInstallReferrerPlatform _instance = MethodChannelFlutterInstallReferrer();

  /// The default instance of [FlutterInstallReferrerPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterInstallReferrer].
  static FlutterInstallReferrerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterInstallReferrerPlatform] when
  /// they register themselves.
  static set instance(FlutterInstallReferrerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<ReferrerDetails?> getInstallReferrer() {
    throw UnimplementedError('getInstallReferrer() has not been implemented.');
  }
}
