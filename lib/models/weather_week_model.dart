import 'dart:convert';
import 'package:location/location.dart';

class WeatherWeek {

  final String? data;

  WeatherWeek({
    required this.data,
  });

  factory WeatherWeek.fromJson(Map<String, dynamic> json) {
    return WeatherWeek(
      data: json["message"]
    );
  }
}
