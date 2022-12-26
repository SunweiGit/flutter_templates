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
      required this.tag});

  String word;
  String radical;
  String id;
  String stroke;
  String explanation;
  String more;
  List pronunciation;
  List pinyin;
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
      more: json['more'],
      explanation: json['explanation'],
    );
  }
}
