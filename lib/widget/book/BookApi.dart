import '../config/setting.dart';
import '../model/basic_request_model.dart';
import '../utils/HttpClientUtils.dart';

class BookHomeApi {
  Future<dynamic> searchBook(
      String param, BasicRequestModel basicRequestModel) {
    var httpClientUtils = HttpClientUtils();
    return httpClientUtils.get(options, "/lionDanceBook/searchBook" + param,
        basicRequestModel.toMap());
  }

  Future<dynamic> getBook(String param, String bookId) {
    var httpClientUtils = HttpClientUtils();
    return httpClientUtils
        .get(options, "/lionDanceBook/getBook" + param, {"bookId": bookId});
  }

  Future<dynamic> getChapterList(String bookId) {
    var httpClientUtils = HttpClientUtils();
    return httpClientUtils
        .get(options, "/lionDanceBook/getChapterList?bookId=" + bookId, {});
  }

  Future<dynamic> getChapter(
    String chapterId,
  ) {
    var httpClientUtils = HttpClientUtils();
    return httpClientUtils
        .get(options, "/lionDanceBook/getChapter?chapterId=" + chapterId, {});
  }
}
