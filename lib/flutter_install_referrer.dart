
import 'flutter_install_referrer_platform_interface.dart';

class ReferrerDetails {
  final String installReferrer;
  final int referrerClickTimestamp;
  final int installBeginTimestamp;
  final bool googlePlayInstantParam;

  ReferrerDetails({
    required this.installReferrer,
    required this.referrerClickTimestamp,
    required this.installBeginTimestamp,
    required this.googlePlayInstantParam,
  });

  factory ReferrerDetails.fromMap(Map<String, dynamic> map) {
    return ReferrerDetails(
      installReferrer: map['installReferrer'] as String,
      referrerClickTimestamp: map['referrerClickTimestamp'] as int,
      installBeginTimestamp: map['installBeginTimestamp'] as int,
      googlePlayInstantParam: map['googlePlayInstantParam'] as bool,
    );
  }
}

class FlutterInstallReferrer {
  static Future<ReferrerDetails?> getInstallReferrer() {
    return FlutterInstallReferrerPlatform.instance.getInstallReferrer();
  }
}
