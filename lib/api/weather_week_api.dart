import 'dart:convert';

import '../utils/location_functionality.dart';
import '../models/weather_model.dart';
import 'package:http/http.dart' as http;

Future<Weather> fetchWeatherForWeek() async {
  var currentLocation = await location.getLocation();

  final response = await http
      .get(Uri.parse('http://api.openweathermap.org/data/2.5/forecast?lat=${currentLocation.latitude}&lon=${currentLocation.longitude}&appid=43ec70748cae1130be4146090de59761'));


  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.

    return Weather.fromJson(jsonDecode(response.body));

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