import 'dart:io';

import 'package:dio/dio.dart';

//const String liondance_gateway_url = "https://gateway.liondance.cn";
const String liondance_gateway_url = "http://localhost:8080";
const String appName = "hello word";
var appVersion = "v1.2022.02.15";
var apiVersion = "v1.2022.03.12";
bool isEncrypt = false;
const Duration cacheDuration = Duration(hours: 1);
var options = BaseOptions(
    baseUrl: liondance_gateway_url,
    connectTimeout: 30000,
    receiveTimeout: 30000,
    headers: {"Access-Control-Allow-Origin": "*"});

var path = Directory.current.path;
