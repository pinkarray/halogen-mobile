import 'dart:io';
import 'package:flutter/services.dart';

/// Holds data that's different on Android and iOS
class PlatformInfo {
  final String userAgent;
  final String paystackBuild;
  final String deviceId;

  static Future<PlatformInfo> fromMethodChannel(MethodChannel channel) async {
    
    final pluginVersion = "1.0.5";
    final platform = Platform.operatingSystem;

    String userAgent = "${platform}_Paystack_$pluginVersion";
    String deviceId = await channel.invokeMethod<String>('getDeviceId') ?? "";

    return PlatformInfo._(
      userAgent: userAgent,
      paystackBuild: pluginVersion,
      deviceId: deviceId,
    );
  }

  const PlatformInfo._({
    required this.userAgent,
    required this.paystackBuild,
    required this.deviceId,
  });

  @override
  String toString() {
    return '[userAgent = $userAgent, paystackBuild = $paystackBuild, deviceId = $deviceId]';
  }
}
