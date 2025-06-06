// import 'package:flutter/services.dart';

// class LocationService {
//   static const MethodChannel _channel = MethodChannel('com.example.spy/data');

//   static Future<void> startTracking(String userId) async {
//     try {
//       await _channel.invokeMethod('startLocationService', {'userId': userId});
//     } on PlatformException catch (e) {
//       print("Failed to start location service: ${e.message}");
//     }
//   }

//   static Future<void> stopTracking() async {
//     try {
//       await _channel.invokeMethod('stopLocationService');
//     } on PlatformException catch (e) {
//       print("Failed to stop location service: ${e.message}");
//     }
//   }
// }

