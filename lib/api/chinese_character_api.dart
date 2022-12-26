import '../config/setting.dart';
import '../model/chinese_character_model.dart';
import '../model/result.dart';
import '../utils/HttpClientUtils.dart';

var httpClientUtils = HttpClientUtils();

main() {
  var api = ChineseCharacterApi();
  var map = {"code": "hello"};
  //Future<dynamic> json = api.search(1, 10, "", '1');
  // json.then((value) => {print(value['result'])});
  late Result result = Result(
      metadata: [],
      totalValue: 0,
      totalRelation: "es",
      scrollId: "",
      page: 0,
      nextPage: false);

  final ChineseCharacterApi chineseCharacterApi = ChineseCharacterApi();

  chineseCharacterApi.search("", result.scrollId, "").then((value) => {
        result = Result.fromJson(Map.from(value)),
        if (result.metadata.isNotEmpty)
          {
            for (final data in result.metadata)
              {print(ChineseCharacter.fromJson(Map.from(data)))}
          }
      });
}

class ChineseCharacterApi {
  Future<dynamic> search(String param, String scrollId, String searchContent) {
    var map = {
      "scrollId": scrollId,
      "searchContent": searchContent,
    };
    return httpClientUtils.getCache(
        options, "/lionDanceChineseCharacter/search" + param, map);
  }

  Future<dynamic> get(String id) {
    return httpClientUtils
        .getCache(options, "/lionDanceChineseCharacter/get/" + id, {});
  }
}
