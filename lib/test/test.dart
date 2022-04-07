import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../app_theme.dart';
import '../model/chinese_character_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: AppTheme.textTheme,
          platform: TargetPlatform.windows,
          fontFamily: "alibaba"),
      home: Scaffold(
          backgroundColor: const Color(0xffffffff),
          body: ListView(children: [
            ChineseCharacterCard(
              chineseCharacter: ChineseCharacter.fromJson({
                "id": "",
                "tag": "",
                "pronunciation": "",
                "sort": "",
                "more": "",
                "explanation": "",
                "word": "贵",
                "pinyin": "guì",
                "radical": "贝",
                "stroke": 9,
                "words": [
                  "鼠凭社贵",
                  "鼎贵",
                  "鬻贵",
                  "骤贵",
                  "骄贵",
                  "靳贵",
                  "靡贵",
                  "雍容华贵",
                  "雅贵",
                  "雄贵",
                  "难能可贵",
                  "隆贵",
                  "降贵纡尊",
                  "降贵",
                  "降尊纡贵",
                  "陆凯贵盛",
                  "阿贵",
                  "长安米贵",
                  "钦贵",
                  "金贵",
                  "金屋贵",
                  "通贵",
                  "轻财贵义",
                  "赵中贵",
                  "贵齿",
                  "贵齐",
                  "贵高",
                  "贵骨",
                  "贵骄",
                  "贵降",
                  "贵际",
                  "贵阶",
                  "贵阀",
                  "贵门",
                  "贵长",
                  "贵金属",
                  "贵里",
                  "贵酋",
                  "贵邸",
                  "贵邦",
                  "贵近",
                  "贵达",
                  "贵躬",
                  "贵身",
                  "贵踞",
                  "贵赫",
                  "贵赤卫",
                  "贵赤",
                  "贵贾",
                  "贵贱"
                ]
              }),
            ),
            ChineseCharacterCard(
              chineseCharacter: ChineseCharacter.fromJson({
                "id": "",
                "tag": "",
                "pronunciation": "",
                "sort": "",
                "more": "",
                "explanation": "",
                "word": "贵",
                "pinyin": "guì",
                "radical": "贝",
                "stroke": 9,
                "words": [
                  "鼠凭社贵",
                  "鼎贵",
                  "鬻贵",
                  "骤贵",
                  "骄贵",
                  "靳贵",
                  "靡贵",
                  "雍容华贵",
                  "雅贵",
                  "雄贵",
                  "难能可贵",
                  "隆贵",
                  "降贵纡尊",
                  "降贵",
                  "降尊纡贵",
                  "陆凯贵盛",
                  "阿贵",
                  "长安米贵",
                  "钦贵",
                  "金贵",
                  "金屋贵",
                  "通贵",
                  "轻财贵义",
                  "赵中贵",
                  "贵齿",
                  "贵齐",
                  "贵高",
                  "贵骨",
                  "贵骄",
                  "贵降",
                  "贵际",
                  "贵阶",
                  "贵阀",
                  "贵门",
                  "贵长",
                  "贵金属",
                  "贵里",
                  "贵酋",
                  "贵邸",
                  "贵邦",
                  "贵近",
                  "贵达",
                  "贵躬",
                  "贵身",
                  "贵踞",
                  "贵赫",
                  "贵赤卫",
                  "贵赤",
                  "贵贾",
                  "贵贱"
                ]
              }),
            )
          ]))));
}

class ChineseCharacterCard extends StatelessWidget {
  const ChineseCharacterCard({required this.chineseCharacter, Key? key})
      : super(key: key);

  final ChineseCharacter chineseCharacter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, right: 6, top: 3, bottom: 3),
      child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage("assets/images/canva_character_02.png"),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          width: 80,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage("assets/images/tianzige.png"),
                            ),
                          ),
                          child: Container(
                            color: Colors.black.withOpacity(.5),
                            child: Center(
                              child: Text(
                                chineseCharacter.word,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 60),
                              ),
                            ),
                          ),
                        )),
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: SizedBox(
                          height: 80,
                          child: Table(
                            columnWidths: const {
                              0: FixedColumnWidth(40),
                              1: FixedColumnWidth(100)
                            },
                            children: [
                              TableRow(
                                children: [
                                  const Text(
                                    "拼音",
                                    style: AppTheme.body1,
                                  ),
                                  Text(chineseCharacter.pinyin)
                                ],
                              ),
                              TableRow(
                                children: [
                                  const Text(
                                    "部首",
                                    style: AppTheme.body1,
                                  ),
                                  Text(chineseCharacter.radical)
                                ],
                              ),
                              TableRow(
                                children: [
                                  const Text(
                                    "笔画",
                                    style: AppTheme.body1,
                                  ),
                                  Text("${chineseCharacter.stroke}  画")
                                ],
                              )
                            ],
                          ),
                        ))
                  ],
                ),
                Container(
                  color: AppTheme.info,
                  height: 2,
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 15, top: 5),
                    child: Row(
                      children: const [
                        Text(
                          "相关词语",
                          textAlign: TextAlign.left,
                          style: AppTheme.title,
                        )
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Wrap(
                    spacing: 6,
                    children: [
                      for (final word in chineseCharacter.words) Text(word),
                    ],
                  ),
                ),
                Container(
                  color: AppTheme.info,
                  height: 2,
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  height: 45,
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Center(
                            child: Container(
                              width: 100,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(32.0)),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.6),
                                      offset: const Offset(4, 4),
                                      blurRadius: 8.0),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {},
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Icon(
                                        FontAwesomeIcons.volumeUp,
                                        size: 12,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        chineseCharacter.word,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Center(
                            child: Container(
                              width: 100,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(32.0)),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.6),
                                      offset: const Offset(4, 4),
                                      blurRadius: 8.0),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {},
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: const [
                                      Icon(
                                        FontAwesomeIcons.eye,
                                        size: 12,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        '查看更多',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
