import 'dart:convert';
import 'package:location/location.dart';

class Weather {

  final String? city;
  final double? temperature;
  final List description;
  final int? humidity;
  final double? wind_speed;


  Weather({
    required this.description,
    required this.humidity,
    required this.wind_speed,
    required this.city,
    required this.temperature,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json['name'],
      temperature: json['main']['temp'],
      description: json['weather'],
      humidity: json['main']['humidity'],
      wind_speed: json['wind']['speed'],
    );
  }
}
