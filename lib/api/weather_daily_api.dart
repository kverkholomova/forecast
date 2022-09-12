import 'dart:convert';

import '../models/weather_daily_model.dart';
import '../utils/location_functionality.dart';

import 'package:http/http.dart' as http;

Future<Weather> fetchWeather() async {
  var currentLocation = await location.getLocation();

  final response = await http
      .get(Uri.parse('http://api.openweathermap.org/data/2.5/weather?lat=${currentLocation.latitude}&lon=${currentLocation.longitude}&appid=43ec70748cae1130be4146090de59761&units=metric'));


  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.

    print("ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZz");
    print(response.body);
    return Future.delayed(Duration(seconds: 2), () => Weather.fromJson(jsonDecode(response.body)));

  }
  else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
    print(response.statusCode);
    print(response.toString());
    throw Exception('Failed to load weather');
  }
}