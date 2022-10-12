

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:forecast/api/weather_week_api.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([http.Client])
void main(){
  test('return error message when http response is unsuccessful',()async{
    // final apiResult = fetchWeather();
    //
    // return Response(jsonEncode(apiResult), 200);


  });
  // expect(fetchWeather(), 200);
}