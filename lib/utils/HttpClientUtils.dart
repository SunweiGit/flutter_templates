import 'dart:convert';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:hive/hive.dart';

import '../config/setting.dart';

void main() async {
  var dio = Dio();
  var cookieJar = CookieJar();
  dio.interceptors.add(CookieManager(cookieJar));
  await dio.get("https://baidu.com/");
  // Print cookies
  print(cookieJar.loadForRequest(Uri.parse("https://baidu.com/")));
  // second request with the cookie
  await dio.get("https://baidu.com/");
}

class HttpClientUtils {
  //进行GET请求
  Future<dynamic> getCache(
      BaseOptions baseOptions, String path, Map<String, dynamic> map) async {
    var box = await Hive.openBox('http_cache');
    var key = generateMD5(apiVersion + path + map.toString());
    // print(box.containsKey(key));
    if (box.containsKey(key)) {
      if (isEncrypt) {
        dynamic decode =
            json.decode(encrypter.decrypt64(await box.get(key), iv: iv));
        // print(decode);
        return decode;
      } else {
        return await box.get(key);
      }
    } else {
      Dio dio = Dio(baseOptions);
      Response response = await dio.get(
        path,
        queryParameters: map,
      );
      switch (response.statusCode) {
        case 200:
          if (isEncrypt) {
            dynamic decode =
                json.decode(encrypter.decrypt64(response.data, iv: iv));
            //print(decode);
            box.put(key, response.data);
            return decode;
          } else {
            box.put(key, response.data);
            return response.data;
          }

        case 401:
          // print(response.statusCode);
          break;
      }
    }
  }

  Future<dynamic> get(
      BaseOptions baseOptions, String path, Map<String, dynamic> map) async {
    Dio dio = Dio(baseOptions);
    Response response = await dio.get(
      path,
      queryParameters: map,
    );
    switch (response.statusCode) {
      case 200:
        return response.data;
      case 401:
        print(response.statusCode);
        break;
    }
  }
}
