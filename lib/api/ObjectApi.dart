import '../config/setting.dart';
import '../utils/HttpClientUtils.dart';

main() {
  var api = ObjectApi();
  var map = {"code": "hello"};
  //Future<dynamic> json = api.search(1, 10, "", '1');
  // json.then((value) => {print(value['result'])});
}

class ObjectApi {
  Future<dynamic> search(
      int pageNum, int sizeNum, String param, String searchContent) {
    var httpClientUtils = HttpClientUtils();
    var map = {
      "page": pageNum,
      "size": sizeNum,
      "searchContent": searchContent,
    };
    return httpClientUtils.getCache(options, "/object/search" + param, map);
  }
}
