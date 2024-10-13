import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_kit/src/core/environment.dart';

final _logInterceptor = LogInterceptor(
  logPrint: (object) => log(object.toString()),
  request: true,
  requestHeader: true,
  requestBody: true,
  responseBody: true,
);

// class DioConfig {
//   final Dio dio;

//   DioConfig({Dio? dio})
//       : dio = dio ??
//             Dio(
//               BaseOptions(
//                 baseUrl: Environment.baseUrl,
//                 headers: {
//                   'Accept': 'application/json',
//                 },
//                 contentType: 'application/json',
//               ),
//             ) {
//     this.dio.interceptors.add(_logInterceptor);
//   }
// }
class DioConfig {
  final Dio dio;

  DioConfig() : dio = Dio() {
    try {
      dio.options.baseUrl = 'https://jsonplaceholder.typicode.com'; // Exemple
      print("DioConfig initialized successfully.");
    } catch (e) {
      print("Error initializing DioConfig: $e");
    }
  }
}
