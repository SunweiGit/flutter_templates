

import '../config/setting.dart';
import '../utils/HttpClientUtils.dart';

main() {
  var api = ChineseCharacterApi();
  var map = {"code": "hello"};
  //Future<dynamic> json = api.search(1, 10, "", '1');
  // json.then((value) => {print(value['result'])});
}

class ChineseCharacterApi {
  Future<dynamic> search(
      int pageNum, int sizeNum, String param, String searchContent) {
    var httpClientUtils = HttpClientUtils();
    var map = {
      "page": pageNum,
      "size": sizeNum,
      "searchContent": searchContent,
    };
    return httpClientUtils.getCache(
        options, "/chineseCharacter/search" + param, map);
  }

  Future<dynamic> findByTag(int pageNum, String param) {
    var httpClientUtils = HttpClientUtils();
    var map = {"page": pageNum, "size": 1};
    return httpClientUtils.getCache(
        options, "/chineseCharacter/findByTag" + param, map);
  }
}
