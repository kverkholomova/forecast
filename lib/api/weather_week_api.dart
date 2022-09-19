import 'dart:convert';

import '../models/weather_week_model.dart';
import '../utils/location_functionality.dart';
import 'package:http/http.dart' as http;

Future<Weather5Days> fetchWeatherForWeek() async {
  var currentLocationData = await location.getLocation();

  final response = await http
      // .get(Uri.parse('http://api.openweathermap.org/data/2.5/forecast?lat=${currentLocationData.latitude}&lon=${currentLocationData.longitude}&cnt=40&appid=43ec70748cae1130be4146090de59761&units=metric'));
      .get(Uri.parse('http://api.openweathermap.org/data/2.5/forecast?q=Mountain%20View&cnt=40&appid=43ec70748cae1130be4146090de59761&units=metric'));


  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Weather5Days.fromJson(jsonDecode(response.body));
  }
  else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load weather');
  }
}