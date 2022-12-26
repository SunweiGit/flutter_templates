import '../config/setting.dart';
import '../model/result.dart';
import '../utils/HttpClientUtils.dart';

main() {
  var recommendApi = RecommendApi();
  late Result result = Result(
      metadata: [],
      totalValue: 0,
      totalRelation: "es",
      scrollId: "",
      page: 0,
      nextPage: false);
  var map = {"code": "hello"};
  Future<dynamic> json = recommendApi.search(result.scrollId, '1');
  json.then((value) => {print(value['result'])});
}

var httpClientUtils = HttpClientUtils();

class RecommendApi {
  Future<dynamic> search(String scrollId, String searchContent) {
    var map = {
      "scrollId": scrollId,
      "searchContent": searchContent,
      "excludes": "@timestamp,@version,sort"
    };
    return httpClientUtils.getCache(options, "/lionDanceRecommend/search", map);
  }
}
