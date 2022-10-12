

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:forecast/api/weather_week_api.dart';
import 'package:forecast/models/weather_week_model.dart';
import 'package:http/http.dart';

void main(){
  test('return error message when http response is unsuccessful',()async{

    final apiResult = {
      "cod":200
    };

    return Response(jsonEncode(apiResult), 200);


  });
  expect(fetchWeatherForWeek(), Future<Weather5Days>);
}