import '../config/setting.dart';
import '../utils/HttpClientUtils.dart';

main() {
  var api = ChineseCharacterApi();
  var map = {"code": "hello"};
  //Future<dynamic> json = api.search(1, 10, "", '1');
  // json.then((value) => {print(value['result'])});
}

var httpClientUtils = HttpClientUtils();

class ChineseCharacterApi {
  Future<dynamic> search(
      int pageNum, int sizeNum, String param, String searchContent) {
    var map = {
      "page": pageNum,
      "size": sizeNum,
      "searchContent": searchContent,
    };
    return httpClientUtils.getCache(
        options, "/chinese_character/search" + param, map);
  }

  Future<dynamic> get(String id) {
    return httpClientUtils
        .getCache(options, "/chinese_character/get/" + id, {});
  }
}
