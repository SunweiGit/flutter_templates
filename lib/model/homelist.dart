import 'package:flutter/widgets.dart';

import '../design_course/home_design_course.dart';
import '../fitness_app/fitness_app_home_screen.dart';
import '../hotel_booking/hotel_home_screen.dart';

class HomeList {
  HomeList({required this.navigateScreen, required this.imagePath});

  Widget navigateScreen;
  String imagePath;

  static List<HomeList> homeList = <HomeList>[
    HomeList(
      navigateScreen: const HotelHomeScreen(),
      imagePath: 'assets/hotel/hotel_booking.png',
    ),
    HomeList(
      navigateScreen: const FitnessAppHomeScreen(),
      imagePath: 'assets/fitness_app/fitness_app.png',
    ),
    HomeList(
      navigateScreen: const DesignCourseHomeScreen(),
      imagePath: 'assets/design_course/design_course.png',
    ),
  ];
}

class Recommend {
  Recommend(
      {required this.navigateScreen,
      required this.route,
      required this.param,
      required this.imageUrl,
      required this.name,
      required this.description,
      required this.id,
      required this.sort});

  Widget navigateScreen;
  String route;
  String param;
  String imageUrl;
  String name;
  String description;
  String sort;
  String id;

  Recommend fromJson(Map<String, dynamic> json) {
    return Recommend(
        navigateScreen: const HotelHomeScreen(),
        route: json['route'],
        param: json['param'],
        imageUrl: json['image_url'],
        name: json['name'],
        description: json['description'],
        sort: json['sort'],
        id: json['id']);
  }
}
