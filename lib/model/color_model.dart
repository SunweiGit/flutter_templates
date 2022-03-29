import 'package:flutter/widgets.dart';

import '../widget/learn_color.dart';

class ColorModel {
  ColorModel(
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

  factory ColorModel.fromJson(Map<String, dynamic> json) {
    return ColorModel(
      navigateScreen: ColorScreenWidget(recommend: json),
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
