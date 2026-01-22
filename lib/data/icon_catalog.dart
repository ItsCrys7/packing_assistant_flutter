import 'package:flutter/material.dart';
import '../common/app_constants.dart';

class IconCatalog {
  static const List<IconData> availableIcons = [
    Icons.home,
    Icons.flight,
    Icons.train,
    Icons.directions_car,
    Icons.hiking,
    Icons.beach_access,
    Icons.school,
    Icons.fitness_center,
    Icons.work,
    Icons.music_note,
    Icons.camera_alt,
    Icons.shopping_bag,
    Icons.pets,
  ];

  static final Map<IconData, String> iconQuotes = {
    Icons.home: AppConstants.quoteHome,
    Icons.flight: AppConstants.quoteFlight,
    Icons.train: AppConstants.quoteTrain,
    Icons.directions_car: AppConstants.quoteCar,
    Icons.hiking: AppConstants.quoteHiking,
    Icons.beach_access: AppConstants.quoteBeach,
    Icons.school: AppConstants.quoteSchool,
    Icons.fitness_center: AppConstants.quoteFitness,
    Icons.work: AppConstants.quoteWork,
    Icons.music_note: AppConstants.quoteMusic,
    Icons.camera_alt: AppConstants.quoteCamera,
    Icons.shopping_bag: AppConstants.quoteShopping,
    Icons.pets: AppConstants.quotePets,
  };
}
