import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:liondance/model/basic_request_model.dart';

import '../api/BookHomeApi.dart';
import '../api/chinese_character_api.dart';
import '../app_theme.dart';
import '../hotel_booking/calendar_popup_view.dart';
import '../hotel_booking/hotel_app_theme.dart';
import '../hotel_booking/hotel_list_view.dart';
import '../hotel_booking/model/hotel_list_data.dart';
import '../hotel_booking/model/popular_filter_list.dart';
import '../hotel_booking/range_slider_view.dart';
import '../hotel_booking/slider_view.dart';
import '../model/chinese_character_model.dart';
import '../model/result.dart';
import 'error_widget.dart';

int page = 1;
int size = 10;
String searchContent = '';
int total = 0;
List<Widget> successList = [];
List<Widget> errorList = [];
RangeValues _values = const RangeValues(1, 20);

class BookHomeScreenWidget extends StatefulWidget {
  Map<String, dynamic> recommend;

  BookHomeScreenWidget({Key? key, required this.recommend})
      : super(key: key);

  @override
  BookHomeScreenState createState() =>
      BookHomeScreenState(recommend: recommend);
}

class BookHomeScreenState extends State<BookHomeScreenWidget>
    with TickerProviderStateMixin {
  BookHomeScreenState({required this.recommend});

  Map<String, dynamic> recommend;
  List<HotelListData> hotelList = HotelListData.hotelList;
  List<Widget> successList = [];
  final ScrollController _scrollController = ScrollController();
  final BookHomeApi bookHomeApi = BookHomeApi();
  final LionDanceAlert lionDanceAlert = LionDanceAlert();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 5));
  BasicRequestModel requestModel =
      BasicRequestModel(searchContent: '', page: 0, size: 30);
  late Result result = Result(metadata: [], totalValue: 0, nextPage: false);
  late final AnimationController animationController;

  @override
  void initState() {
    super.initState();
    getData();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
  }

  @override
  void dispose() {
    searchContent = '';
    successList.clear();
    animationController.dispose();
    super.dispose();
  }

  getData() {
    bookHomeApi.searchBook(recommend['param'], requestModel)
        .onError((error, stackTrace) =>
            ({lionDanceAlert.retryAlert(context, getData)}))
        .then((value) => {
              setState(() {
                result = Result.fromJson(Map.from(value));
                List metadata = result.metadata;
                if (metadata.isNotEmpty) {
                  for (final data in metadata) {
                    successList.add(BookHomeCard(
                      BookHome:
                          BookHome.fromJson(Map.from(data)),
                    ));
                  }
                }
                requestModel.page = requestModel.page + 1;
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Theme(
        data: HotelAppTheme.buildLightTheme(),
        child: Stack(
          children: <Widget>[
            InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Column(
                children: <Widget>[
                  getAppBarUI(),
                  //getSearchBarUI(),
                  //getFilterBarUI(),
                  Expanded(
                    child: NestedScrollView(
                      controller: _scrollController,
                      headerSliverBuilder:
                          (BuildContext context, bool innerBoxIsScrolled) {
                        return <Widget>[
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                              return Column(
                                children: <Widget>[
                                   //getSearchBarUI(),
                                ],
                              );
                            }, childCount: 1),
                          ),
                          SliverPersistentHeader(
                            pinned: true,
                            floating: true,
                            delegate: ContestTabHeader(
                              getSearchBarUI(),
                            ),
                          ),
                        ];
                      },
                      body: Container(
                          color:
                              HotelAppTheme.buildLightTheme().backgroundColor,
                          child: EasyRefresh(
                            onRefresh: () async {
                              successList.clear();
                              requestModel.page = 0;
                              getData();
                            },
                            onLoad: () async {
                              getData();
                            },
                            child: ListView.builder(
                              itemCount: successList.length,
                              padding: const EdgeInsets.only(top: 8),
                              itemBuilder: (BuildContext context, int index) {
                                animationController.forward();
                                return successList[index];
                              },
                            ),
                          )),
                    ),
                  ),
                  if (errorList.isNotEmpty) errorList.first
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getListUI() {
    return Container(
      decoration: BoxDecoration(
        color: HotelAppTheme.buildLightTheme().backgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, -2),
              blurRadius: 8.0),
        ],
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height - 156 - 50,
            child: FutureBuilder<bool>(
              future: getData(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                } else {
                  return ListView.builder(
                    itemCount: hotelList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final int count =
                          hotelList.length > 10 ? 10 : hotelList.length;
                      final Animation<double> animation =
                          Tween<double>(begin: 0.0, end: 1.0).animate(
                              CurvedAnimation(
                                  parent: animationController,
                                  curve: Interval((1 / count) * index, 1.0,
                                      curve: Curves.fastOutSlowIn)));
                      animationController.forward();

                      return HotelListView(
                        callback: () {},
                        hotelData: hotelList[index],
                        animation: animation,
                        animationController: animationController,
                      );
                    },
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget getHotelViewList() {
    final List<Widget> hotelListViews = <Widget>[];
    for (int i = 0; i < hotelList.length; i++) {
      final int count = hotelList.length;
      final Animation<double> animation =
          Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Interval((1 / count) * i, 1.0, curve: Curves.fastOutSlowIn),
        ),
      );
      hotelListViews.add(
        HotelListView(
          callback: () {},
          hotelData: hotelList[i],
          animation: animation,
          animationController: animationController,
        ),
      );
    }
    animationController.forward();
    return Column(
      children: hotelListViews,
    );
  }

  Widget getTimeDateUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 18, bottom: 16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                InkWell(
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  splashColor: Colors.grey.withOpacity(0.2),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(4.0),
                  ),
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    // if (mounted) {
                    //   setState(() {
                    //     isDatePopupOpen = true;
                    //   });
                    // }
                    showDemoDialog(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8, right: 8, top: 4, bottom: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Choose date',
                          style: TextStyle(
                              fontWeight: FontWeight.w100,
                              fontSize: 16,
                              color: Colors.grey.withOpacity(0.8)),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          '${DateFormat('dd, MMM').format(startDate)} - ${DateFormat('dd, MMM').format(endDate)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w100,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              width: 1,
              height: 42,
              color: Colors.grey.withOpacity(0.8),
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                InkWell(
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  splashColor: Colors.grey.withOpacity(0.2),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(4.0),
                  ),
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8, right: 8, top: 4, bottom: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Number of Rooms',
                          style: TextStyle(
                              fontWeight: FontWeight.w100,
                              fontSize: 16,
                              color: Colors.grey.withOpacity(0.8)),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Text(
                          '1 Room - 2 Adults',
                          style: TextStyle(
                            fontWeight: FontWeight.w100,
                            fontSize: 16,
                          ),
                        ),
                      ],
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

  Widget getSearchBarUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 2, bottom: 2),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 2, bottom: 2),
              child: Container(
                decoration: BoxDecoration(
                  color: HotelAppTheme.buildLightTheme().backgroundColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(38.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: const Offset(0, 2),
                        blurRadius: 8.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 2, bottom: 2),
                  child: TextField(
                    onChanged: (String txt) {
                      requestModel.page=0;
                      requestModel.searchContent= txt;
                    },
                    onSubmitted: (String txt) {
                      requestModel.searchContent= txt;
                      requestModel.page=0;
                      successList.clear();
                      getData();
                    },
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    cursorColor: HotelAppTheme.buildLightTheme().primaryColor,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "输入您要查询的汉字...",
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: HotelAppTheme.buildLightTheme().primaryColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(38.0),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    offset: const Offset(0, 2),
                    blurRadius: 8.0),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.all(
                  Radius.circular(32.0),
                ),
                onTap: () {
                  requestModel.page=0;
                  successList.clear();
                  getData();
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(FontAwesomeIcons.searchengin,
                      size: 20,
                      color: HotelAppTheme.buildLightTheme().backgroundColor),
                ),
              ),
            ),
          )
          ,
          Material(
            color: Colors.transparent,
            child: InkWell(
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              splashColor: Colors.grey.withOpacity(0.2),
              borderRadius: const BorderRadius.all(
                Radius.circular(4.0),
              ),
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                Navigator.push<dynamic>(
                  context,
                  MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) =>
                      const FiltersScreen(),
                      fullscreenDialog: true),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.sort_outlined,
                          size: 40,
                          color: HotelAppTheme.buildLightTheme()
                              .primaryColor),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget getFilterBarUI() {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 24,
            decoration: BoxDecoration(
              color: HotelAppTheme.buildLightTheme().backgroundColor,
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    offset: const Offset(0, -2),
                    blurRadius: 8.0),
              ],
            ),
          ),
        ),
        Container(
          color: HotelAppTheme.buildLightTheme().backgroundColor,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '$total',
                      style: const TextStyle(
                        fontWeight: FontWeight.w100,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      Navigator.push<dynamic>(
                        context,
                        MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) =>
                                const FiltersScreen(),
                            fullscreenDialog: true),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(
                        children: <Widget>[
                          const Text(
                            'Filter',
                            style: TextStyle(
                              fontWeight: FontWeight.w100,
                              fontSize: 16,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.sort,
                                color: HotelAppTheme.buildLightTheme()
                                    .primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Divider(
            height: 1,
          ),
        )
      ],
    );
  }

  void showDemoDialog(BuildContext context) {
    showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) => CalendarPopupView(
        minimumDate: DateTime.now(),
        //  maximumDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 10),
        initialEndDate: endDate,
        initialStartDate: startDate,
        onApplyClick: (DateTime startData, DateTime endData) {
          if (mounted) {
            setState(() {
              startDate = startData;
              endDate = endData;
            });
          }
        },
        onCancelClick: () {},
      ),
    );
  }

  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: HotelAppTheme.buildLightTheme().backgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 8.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Material(
          child: Row(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                width: AppBar().preferredSize.height + 40,
                height: AppBar().preferredSize.height,
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(32.0)),
                  onTap: () => Navigator.pop(context),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.home_outlined),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    recommend['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: AppBar().preferredSize.height + 40,
                height: AppBar().preferredSize.height,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                      onTap: () {},
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.favorite_border),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ContestTabHeader extends SliverPersistentHeaderDelegate {
  ContestTabHeader(
    this.searchUI,
  );

  final Widget searchUI;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return searchUI;
  }

  @override
  double get maxExtent => 52.0;

  @override
  double get minExtent => 52.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class BookHomeCard extends StatelessWidget {
  const BookHomeCard({required this.BookHome, Key? key})
      : super(key: key);

  final BookHome BookHome;

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
                                BookHome.word,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 60),
                              ),
                            ),
                          ),
                        )),
                    Expanded(
                        child: Row(children: [
                      Expanded(
                          flex: 1,
                          child: Column(
                            children: const [
                              Text(
                                "拼音",
                                style: AppTheme.body1,
                              ),
                              Text(
                                "部首",
                                style: AppTheme.body1,
                              ),
                              Text(
                                "笔画",
                                style: AppTheme.body1,
                              ),
                            ],
                          )),
                      Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  for (final v in BookHome.pinyin)
                                    Text(v['key'])
                                ],
                              ),
                              Text(BookHome.radical),
                              Text("${BookHome.stroke}")
                            ],
                          ))
                    ])),
                  ],
                ),
                if (BookHome.words.isNotEmpty)
                  Column(
                    children: [
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
                            for (final word in BookHome.words)
                              Text(word['key']),
                          ],
                        ),
                      ),
                    ],
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
                                        BookHome.word,
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

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({Key? key}) : super(key: key);

  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  List<PopularFilterListData> popularFilterListData =
      PopularFilterListData.popularFList;
  List<PopularFilterListData> accomodationListData =
      PopularFilterListData.accomodationList;

  double distValue = 50.0;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: HotelAppTheme.buildLightTheme().backgroundColor,
      child: Column(
        children: <Widget>[
          getAppBarUI(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  strokesFilter(),
                  const Divider(
                    height: 2,
                  ),
                  tagFilter(),
                  const Divider(
                    height: 2,
                  ),
                  distanceViewUI(),
                  const Divider(
                    height: 2,
                  ),
                  allAccommodationUI()
                ],
              ),
            ),
          ),
          const Divider(
            height: 1,
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: HotelAppTheme.buildLightTheme().primaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.6),
                    blurRadius: 8,
                    offset: const Offset(4, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                  highlightColor: Colors.transparent,
                  onTap: () => Navigator.pop(context),
                  child: const Center(
                    child: Text(
                      '确定',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget allAccommodationUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text(
            'Type of Accommodation',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 16),
          child: Column(
            children: getAccomodationListUI(),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  List<Widget> getAccomodationListUI() {
    final List<Widget> noList = <Widget>[];
    for (int i = 0; i < accomodationListData.length; i++) {
      final PopularFilterListData date = accomodationListData[i];
      noList.add(
        InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(4.0)),
          onTap: () {
            if (mounted) {
              setState(() {
                checkAppPosition(i);
              });
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    date.titleTxt,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                CupertinoSwitch(
                  activeColor: date.isSelected
                      ? HotelAppTheme.buildLightTheme().primaryColor
                      : Colors.grey.withOpacity(0.6),
                  onChanged: (bool value) {
                    if (mounted) {
                      setState(() {
                        checkAppPosition(i);
                      });
                    }
                  },
                  value: date.isSelected,
                ),
              ],
            ),
          ),
        ),
      );
      if (i == 0) {
        noList.add(const Divider(
          height: 1,
        ));
      }
    }
    return noList;
  }

  void checkAppPosition(int index) {
    if (index == 0) {
      if (accomodationListData[0].isSelected) {
        for (final PopularFilterListData data in accomodationListData) {
          data.isSelected = false;
        }
      } else {
        for (final PopularFilterListData data in accomodationListData) {
          data.isSelected = true;
        }
      }
    } else {
      accomodationListData[index].isSelected =
          !accomodationListData[index].isSelected;

      int count = 0;
      for (int i = 0; i < accomodationListData.length; i++) {
        if (i != 0) {
          final PopularFilterListData data = accomodationListData[i];
          if (data.isSelected) {
            count += 1;
          }
        }
      }

      if (count == accomodationListData.length - 1) {
        accomodationListData[0].isSelected = true;
      } else {
        accomodationListData[0].isSelected = false;
      }
    }
  }

  Widget distanceViewUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text(
            'Distance from city center',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        SliderView(
          distValue: distValue,
          onChangedistValue: (double value) {
            distValue = value;
          },
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget tagFilter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text(
            '标签',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 16),
          child: Column(
            children: getPList(),
          ),
        ),
        const SizedBox(
          height: 8,
        )
      ],
    );
  }

  List<Widget> getPList() {
    final List<Widget> noList = <Widget>[];
    int count = 0;
    const int columnCount = 2;
    for (int i = 0; i < popularFilterListData.length / columnCount; i++) {
      final List<Widget> listUI = <Widget>[];
      for (int i = 0; i < columnCount; i++) {
        try {
          final PopularFilterListData date = popularFilterListData[count];
          listUI.add(Expanded(
            child: Row(
              children: <Widget>[
                InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                  onTap: () {
                    if (mounted) {
                      setState(() {
                        date.isSelected = !date.isSelected;
                      });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          date.isSelected
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: date.isSelected
                              ? HotelAppTheme.buildLightTheme().primaryColor
                              : Colors.grey.withOpacity(0.6),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          date.titleTxt,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ));
          if (count < popularFilterListData.length - 1) {
            count += 1;
          } else {
            break;
          }
        } catch (e) {
          debugPrint('filters_screen.dart: $e');
        }
      }
      noList.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: listUI,
      ));
    }
    return noList;
  }

  //笔画过滤器
  Widget strokesFilter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            '笔画范围',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: _values.start.round(),
                      child: const SizedBox(),
                    ),
                    SizedBox(
                        width: 54,
                      child: Text(
                        '${_values.start.round()} \画',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 60 - _values.start.round(),
                      child: const SizedBox(),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: _values.end.round(),
                      child: const SizedBox(),
                    ),
                    SizedBox(
                      width: 54,
                      child: Text(
                        '${_values.end.round()} \画',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 60 - _values.end.round(),
                      child: const SizedBox(),
                    ),
                  ],
                ),
              ],
            ),
            SliderTheme(
              data: SliderThemeData(
                rangeThumbShape: CustomRangeThumbShape(),
              ),
              child: RangeSlider(
                values: _values,
                max: 60.0,
                activeColor: HotelAppTheme.buildLightTheme().primaryColor,
                inactiveColor: Colors.grey.withOpacity(0.4),
                divisions: 60,
                onChanged: (RangeValues values) {
                  try {
                    if (mounted) {
                      setState(() {
                        _values = values;
                      });
                    }
                    //widget.onChangeRangeValues(_values);
                  } catch (_) {}
                },
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 8,
        )
      ],
    );
  }

  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: HotelAppTheme.buildLightTheme().backgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 4.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: InkWell(
                borderRadius: const BorderRadius.all(
                  Radius.circular(32.0),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.close),
                ),
              ),
            ),
            const Expanded(
              child: Center(
                child: Text(
                  '过滤器',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
            )
          ],
        ),
      ),
    );
  }
}
