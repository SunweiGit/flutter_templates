import '../config/setting.dart';
import '../utils/HttpClientUtils.dart';

main() {
  var httpClientUtils = HttpClientUtils();
  var map = {"code": "hello"};
  Future<dynamic> json = httpClientUtils.getCache(options, "/getMessage", map);
  json.then((value) => {print(value)});
}
