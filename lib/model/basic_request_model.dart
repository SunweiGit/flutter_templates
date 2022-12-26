class ChineseCharacterRequestModel {
  ChineseCharacterRequestModel({
    required this.page,
    required this.searchContent,
    required this.size,
  });

  int page;
  int size;
  String searchContent;

  Map<String, dynamic> toMap() {
    return {'page': page, 'size': size, 'searchContent': searchContent};
  }
}
