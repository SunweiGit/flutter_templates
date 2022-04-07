import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:liondance/widget/ParallaxWidget.dart';
import 'package:liondance/widget/error_widget.dart';

import 'api/recommendApi.dart';
import 'app_theme.dart';
import 'config/setting.dart';
import 'model/home_list.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  List<Recommend> successList = [];
  List<Widget> errorList = [];
  bool multiple = true;
  int page = 1;
  int size = 10;

  late final AnimationController animationController;
  late final RecommendApi recommendApi = RecommendApi();

  @override
  void initState() {
    //print(page);
    getData();
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
  }

  getData() {
    recommendApi
        .search(page, size, '')
        .then((value) => {
              setState(() {
                List result = value['result'];
                if (result.isNotEmpty) {
                  for (final recommend in result) {
                    successList.add(Recommend.fromJson(Map.from(recommend)));
                  }
                } else {
                  page--;
                }
              })
            })
        .onError((error, stackTrace) => {
              errorList.clear(),
              errorList.add(RetryWidget(
                onTapCallback: getData(),
              )),
            });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          appBar(),
          Expanded(
            child: EasyRefresh(
                onRefresh: () async {
                  successList.clear();
                  page = 1;
                  getData();
                },
                onLoad: () async {
                  page++;
                  getData();
                },
                child: GridView(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: multiple ? 2 : 1,
                    mainAxisSpacing: 1.0,
                    crossAxisSpacing: 1.0,
                    childAspectRatio: 1.5,
                  ),
                  children: List<Widget>.generate(
                    successList.length,
                    (int index) {
                      final int count = successList.length;
                      final Animation<double> animation =
                          Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: animationController,
                          curve: Interval((1 / count) * index, 1.0,
                              curve: Curves.fastOutSlowIn),
                        ),
                      );
                      animationController.forward();
                      return HomeListView(
                        animation: animation,
                        animationController: animationController,
                        data: successList[index],
                        callBack: () {
                          Navigator.push<dynamic>(
                            context,
                            MaterialPageRoute<dynamic>(
                              builder: (BuildContext context) =>
                                  successList[index].navigateScreen,
                            ),
                          );
                        },
                      );
                    },
                  ),
                )),
          ),
          if (errorList.isNotEmpty) Expanded(child: errorList.first),
        ],
      ),
    );
  }

  Widget appBar() {
    return SizedBox(
      height: AppBar().preferredSize.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 8),
            child: SizedBox(
              width: AppBar().preferredSize.height - 8,
              height: AppBar().preferredSize.height - 8,
            ),
          ),
          const Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  appName,
                  style: TextStyle(
                    fontSize: 22,
                    color: AppTheme.darkText,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, right: 8),
            child: Container(
              width: AppBar().preferredSize.height - 8,
              height: AppBar().preferredSize.height - 8,
              color: Colors.white,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius:
                      BorderRadius.circular(AppBar().preferredSize.height),
                  onTap: () {
                    if (mounted) {
                      setState(() {
                        multiple = !multiple;
                      });
                    }
                  },
                  child: Icon(
                    multiple ? Icons.dashboard : Icons.view_agenda,
                    color: AppTheme.darkGrey,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeListView extends StatelessWidget {
  const HomeListView(
      {required this.data,
      required this.callBack,
      required this.animationController,
      required this.animation,
      Key? key})
      : super(key: key);

  final Recommend data;
  final VoidCallback callBack;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, _) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation.value), 0.0),
            child: AspectRatio(
              aspectRatio: 1.5,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                child: InkWell(
                  splashColor: Colors.grey.withOpacity(0.2),
                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                  onTap: () => callBack(),
                  child: ParallaxWidget(recommend: data),
                ),
              ),
            ),
          ),
        );
      },
    );
    InkWell(
      splashColor: Colors.grey.withOpacity(0.2),
      borderRadius: const BorderRadius.all(Radius.circular(4.0)),
      onTap: () => callBack(),
      child: ParallaxWidget(recommend: data),
    );
    AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, _) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation.value), 0.0),
            child: AspectRatio(
              aspectRatio: 1.5,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    Image.asset(
                      data.imageUrl,
                      fit: BoxFit.cover,
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.grey.withOpacity(0.2),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4.0)),
                        onTap: () => callBack(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
