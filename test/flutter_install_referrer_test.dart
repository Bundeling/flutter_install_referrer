import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_install_referrer/flutter_install_referrer.dart';
import 'package:flutter_install_referrer/flutter_install_referrer_platform_interface.dart';
import 'package:flutter_install_referrer/flutter_install_referrer_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterInstallReferrerPlatform
    with MockPlatformInterfaceMixin
    implements FlutterInstallReferrerPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterInstallReferrerPlatform initialPlatform = FlutterInstallReferrerPlatform.instance;

  test('$MethodChannelFlutterInstallReferrer is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterInstallReferrer>());
  });

  test('getPlatformVersion', () async {
    FlutterInstallReferrer flutterInstallReferrerPlugin = FlutterInstallReferrer();
    MockFlutterInstallReferrerPlatform fakePlatform = MockFlutterInstallReferrerPlatform();
    FlutterInstallReferrerPlatform.instance = fakePlatform;

    expect(await flutterInstallReferrerPlugin.getPlatformVersion(), '42');
  });
}
