import '../config/setting.dart';
import '../utils/HttpClientUtils.dart';

main() {
  var recommendApi = RecommendApi();
  var map = {"code": "hello"};
  Future<dynamic> json = recommendApi.search(1, 10, '1');
  json.then((value) => {print(value['result'])});
}

class RecommendApi {
  Future<dynamic> search(int pageNum, int sizeNum, String searchContent) {
    var httpClientUtils = HttpClientUtils();
    var map = {
      "page": pageNum,
      "size": sizeNum,
      "searchContent": searchContent
    };
    return httpClientUtils.getCache(options, "/recommend/search", map);
  }
}
