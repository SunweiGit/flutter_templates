import 'dart:convert';
import 'dart:io';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart';
import 'package:hive/hive.dart';
//const String liondance_gateway_url = "https://gateway.liondance.cn";
const String liondance_gateway_url = "http://localhost:8080";
const String appName = "lion dance";
var appVersion = "v1.2022.02.15";
var apiVersion = "v1.2022.03.12";
final key = Key.fromUtf8('axap1tanexmj7kiveunnawse');
final iv = IV.fromUtf8("1954682228745975");
final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

bool isEncrypt = false;
const Duration cacheDuration = Duration(hours: 1);
var options = BaseOptions(
    sendTimeout: 30000,
    baseUrl: liondance_gateway_url,
    connectTimeout: 30000,
    receiveTimeout: 30000,
    headers: {"Access-Control-Allow-Origin": "*"});

// md5 加密
String generateMD5(String data) {
  var content = const Utf8Encoder().convert(data);
  var digest = md5.convert(content);
  // 这里其实就是 digest.toString()
  return hex.encode(digest.bytes);
}
