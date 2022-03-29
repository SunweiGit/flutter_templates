import 'package:adobe_xd/pinned.dart';
import 'package:flutter/material.dart';

import '../app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: AppTheme.textTheme,
        platform: TargetPlatform.macOS,
        fontFamily: "alibaba"),
    home: IPhone12ProMax1(),
  ));
}

class IPhone12ProMax1 extends StatelessWidget {
  IPhone12ProMax1({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: Stack(
        children: <Widget>[
          Pinned.fromPins(
            Pin(start: 9.0, end: 9.0),
            Pin(size: 237.0, middle: 0.2496),
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    borderRadius: BorderRadius.circular(12.0),
                    border:
                        Border.all(width: 3.0, color: const Color(0xff53d3c2)),
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 150.0, start: 11.0),
                  Pin(size: 150.0, start: 11.0),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: const AssetImage('assets/images/img.png'),
                            fit: BoxFit.cover,
                          ),
                          border: Border.all(
                              width: 1.0, color: const Color(0xff53d3c2)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 9.0, 16.0, 14.0),
                        child: SizedBox.expand(
                            child: Text(
                          '你',
                          style: TextStyle(
                            fontSize: 124,
                            color: const Color(0xff707070),
                          ),
                          softWrap: false,
                        )),
                      ),
                    ],
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 46.0, middle: 0.4835),
                  Pin(size: 24.0, start: 11.0),
                  child: Text(
                    '拼音',
                    style: TextStyle(
                      fontSize: 23,
                      color: const Color(0xff000000),
                    ),
                    softWrap: false,
                  ),
                ),
                Align(
                  alignment: Alignment(-0.033, -0.521),
                  child: SizedBox(
                    width: 46.0,
                    height: 24.0,
                    child: Text(
                      '部首',
                      style: TextStyle(
                        fontSize: 23,
                        color: const Color(0xff000000),
                      ),
                      softWrap: false,
                    ),
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 19.0, middle: 0.624),
                  Pin(size: 23.0, start: 12.0),
                  child: Text(
                    'nǐ',
                    style: TextStyle(
                      fontSize: 23,
                      color: const Color(0xff000000),
                    ),
                    softWrap: false,
                  ),
                ),
                Align(
                  alignment: Alignment(0.261, -0.521),
                  child: SizedBox(
                    width: 23.0,
                    height: 24.0,
                    child: Text(
                      '亻',
                      style: TextStyle(
                        fontSize: 23,
                        color: const Color(0xff000000),
                      ),
                      softWrap: false,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment(-0.033, -0.075),
                  child: SizedBox(
                    width: 46.0,
                    height: 23.0,
                    child: Text(
                      '词语',
                      style: TextStyle(
                        fontSize: 23,
                        color: const Color(0xff000000),
                      ),
                      softWrap: false,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment(0.564, -0.07),
                  child: SizedBox(
                    width: 98.0,
                    height: 24.0,
                    child: Text(
                      '你好 你们',
                      style: TextStyle(
                        fontSize: 23,
                        color: const Color(0xff000000),
                      ),
                      softWrap: false,
                    ),
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 153.0, start: 11.0),
                  Pin(size: 53.0, end: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xff53d3c2),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 153.0, end: 12.0),
                  Pin(size: 53.0, end: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xff53d3c2),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 46.0, middle: 0.1786),
                  Pin(size: 30.0, end: 26.0),
                  child: Text(
                    '朗读',
                    style: TextStyle(
                      fontSize: 23,
                      color: const Color(0xff222222),
                    ),
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 92.0, end: 42.0),
                  Pin(size: 30.0, end: 22.0),
                  child: Text(
                    '查看更多',
                    style: TextStyle(
                      fontSize: 23,
                      color: const Color(0xff222222),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
