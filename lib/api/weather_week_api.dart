import 'dart:convert';

import '../models/weather_week_model.dart';
import '../utils/location_functionality.dart';
import '../models/weather_daily_model.dart';
import 'package:http/http.dart' as http;

Future<Weather5Days> fetchWeatherForWeek() async {
  var currentLocation_data = await location.getLocation();

  print("WWWWWWWWWWWWWWWWWWWWWWWWork");
  final response = await http
      .get(Uri.parse('http://api.openweathermap.org/data/2.5/forecast?lat=${currentLocation_data.latitude}&lon=${currentLocation_data.longitude}&cnt=40&appid=43ec70748cae1130be4146090de59761&units=metric'));


  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.

    print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
    print(response.statusCode);
    print(response.body);

    return Weather5Days.fromJson(jsonDecode(response.body));

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