import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:location/location.dart';

var location = new Location();
// var currentLocation;
// Future<void> getCurrentLocation() async{
//   currentLocation = await location.getLocation();
//   print("RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR");
//   print(currentLocation.longitude);
// }

Future<void> serviceEn() async{
var serviceEnabled = await location.serviceEnabled();
if(!serviceEnabled){
  serviceEnabled = await location.requestService();
  if(!serviceEnabled){
    return;
  }
}
}

Future<void> permissGranted() async{
  var permissionGranted = await location.hasPermission();
  if(permissionGranted == PermissionStatus.denied){
    permissionGranted = await location.requestPermission();
  }
  if(permissionGranted != PermissionStatus.granted){
    return;
  }
}



Future<Weather> fetchWeather() async {
    var currentLocation = await location.getLocation();
    print("RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR");
    print(currentLocation.longitude);

  final response = await http
      .get(Uri.parse('http://api.openweathermap.org/data/2.5/weather?lat=${currentLocation.latitude}&lon=${currentLocation.longitude}&appid=43ec70748cae1130be4146090de59761&units=metric'));


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

class Weather {
  final String? city;

  const Weather({
    required this.city,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json['name'],
    );
  }
}

// class WeatherModel{
//   static String weatherModel = '''[
//   {
//
//   }
//   ]
//   ''';
// }