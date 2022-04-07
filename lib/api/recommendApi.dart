import '../config/setting.dart';
import '../utils/HttpClientUtils.dart';

main() {
  var recommendApi = RecommendApi();
  var map = {"code": "hello"};
  Future<dynamic> json = recommendApi.search(1, 10, '1');
  json.then((value) => {print(value['result'])});
}

var httpClientUtils = HttpClientUtils();

class RecommendApi {
  Future<dynamic> search(int pageNum, int sizeNum, String searchContent) {
    var map = {
      "page": pageNum,
      "size": sizeNum,
      "searchContent": searchContent,
      "excludes": "@timestamp,@version,sort"
    };
    return httpClientUtils.getCache(options, "/recommend/search", map);
  }
}
