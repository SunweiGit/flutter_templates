import 'package:flutter/widgets.dart';

import '../widget/learn_chinese_characters.dart';

class ChineseCharacter {
  ChineseCharacter(
      {required this.navigateScreen,
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

  Widget navigateScreen;
  dynamic word;
  dynamic pinyin;
  dynamic pronunciation;
  dynamic stroke;
  dynamic radical;
  dynamic explanation;
  dynamic more;
  dynamic id;
  dynamic sort;
  dynamic tag;

  factory ChineseCharacter.fromJson(Map<String, dynamic> json) {
    return ChineseCharacter(
      navigateScreen: ChineseCharacterScreenWidget(recommend: json),
      word: json['word'],
      pinyin: json['pinyin'],
      radical: json['radical'],
      stroke: json['stroke'],
      id: json['id'],
      tag: json['tag'],
      pronunciation: json['pronunciation'],
      sort: json['sort'],
      more: json['more'],
      explanation: json['explanation'],
    );
  }
}
