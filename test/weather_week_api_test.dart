

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:forecast/api/weather_week_api.dart';
import 'package:forecast/models/weather_week_model.dart';
import 'package:forecast/screens/today_forecast.dart';
import 'package:forecast/utils/location_functionality.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import 'weather_week_api_test.mocks.dart';

@GenerateMocks([http.Client])
void main(){
  group('fetchWeather', () {
    test('returns weather if the http call completes successfully', () async {
      final client = MockClient();
      var currentLocationData = await location.getLocation();
      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(client
          .get(Uri.parse(city!=""?'http://api.openweathermap.org/data/2.5/forecast?q=$city&cnt=40&appid=43ec70748cae1130be4146090de59761&units=metric':'http://api.openweathermap.org/data/2.5/forecast?lat=${currentLocationData.latitude}&lon=${currentLocationData.longitude}&cnt=40&appid=43ec70748cae1130be4146090de59761&units=metric')))
          .thenAnswer((_) async =>
          http.Response('{"cod": 200, "message": 0, "cnt": 40, "list": [{...}], "city": Warsaw}', 200));

      expect(await fetchWeather(client), isA<Weather5Days>());
    });

    test('throws an exception if the http call completes with an error', () {
      final client = MockClient();

      // Use Mockito to return an unsuccessful response when it calls the
      // provided http.Client.
      when(client
          .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(fetchWeather(client), throwsException);
    });
  });
  // test('return error message when http response is unsuccessful',()async{
  //   // final apiResult = fetchWeather();
  //   //
  //   // return Response(jsonEncode(apiResult), 200);
  //
  //
  // });
  // expect(fetchWeather(), 200);
}