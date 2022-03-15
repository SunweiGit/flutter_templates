import '../config/setting.dart';
import '../utils/HttpClientUtils.dart';

main() {
  var map = {"code": "hello"};
  // Future<dynamic> json = recommendApi.search(1, 10, '1');
  // json.then((value) => {print(value['result'])});
}

class ConfigApi {
  Future<dynamic> systemInfo() {
    var httpClientUtils = HttpClientUtils();
    var map = {"system": appName};
    return httpClientUtils.get(options, "/config/systemInfo", map);
  }
}
