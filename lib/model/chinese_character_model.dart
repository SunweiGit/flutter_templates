class ChineseCharacter {
  ChineseCharacter(
      {required this.words,
      required this.word,
      required this.pinyin,
      required this.pronunciation,
      required this.stroke,
      required this.radical,
      required this.explanation,
      required this.more,
      required this.id,
      required this.sort,
      required this.tag});

  String word;
  String pinyin;
  String radical;
  String id;
  int sort;
  String pronunciation;
  int stroke;
  String explanation;
  String more;
  List words;
  List tag;

  factory ChineseCharacter.fromJson(Map<String, dynamic> json) {
    return ChineseCharacter(
      word: json['word'],
      pinyin: json['pinyin'],
      radical: json['radical'],
      stroke: json['stroke'],
      words: json['words'],
      id: json['id'],
      tag: json['tag'],
      pronunciation: json['pronunciation'],
      sort: json['sort'],
      more: json['more'],
      explanation: json['explanation'],
    );
  }
}
