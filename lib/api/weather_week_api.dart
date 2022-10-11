import 'dart:convert';

import '../models/weather_week_model.dart';
import '../screens/today_forecast.dart';
import '../utils/location_functionality.dart';
import 'package:http/http.dart' as http;

bool rightCity = true;

String? url;
Future<Weather5Days> fetchWeatherForWeek() async {
  var currentLocationData = await location.getLocation();
  url = city!=""?'http://api.openweathermap.org/data/2.5/forecast?q=$city&cnt=40&appid=43ec70748cae1130be4146090de59761&units=metric':'http://api.openweathermap.org/data/2.5/forecast?lat=${currentLocationData.latitude}&lon=${currentLocationData.longitude}&cnt=40&appid=43ec70748cae1130be4146090de59761&units=metric';

  final response = await http
      .get(Uri.parse(city!=""?'http://api.openweathermap.org/data/2.5/forecast?q=$city&cnt=40&appid=43ec70748cae1130be4146090de59761&units=metric':'http://api.openweathermap.org/data/2.5/forecast?lat=${currentLocationData.latitude}&lon=${currentLocationData.longitude}&cnt=40&appid=43ec70748cae1130be4146090de59761&units=metric'));
      // .get(Uri.parse('http://api.openweathermap.org/data/2.5/forecast?q=Mountain%20View&cnt=40&appid=43ec70748cae1130be4146090de59761&units=metric'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Weather5Days.fromJson(jsonDecode(response.body));
  }
  // } else if (response.statusCode == 404) {
  //   // If the server did return a 200 OK response,
  //   // then parse the JSON.;
  // }
  else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    rightCity = false;

    throw Exception('Error ${response.statusCode}');
  }
}