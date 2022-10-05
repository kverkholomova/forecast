import 'dart:convert';

import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_db_helper.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/material.dart';
import 'package:forecast/screens/exception_screen.dart';

import '../models/weather_week_model.dart';
import '../screens/today_forecast.dart';
import '../utils/location_functionality.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

bool rightCity = true;

// Future<List<Map<String, dynamic>>> fetchapiCach() async {
//   // await APICacheDBHelper.deleteAll(APICacheDBModel.table);
//
//   var lists = new List<int>.generate(10, (i) => i + 1);
//   lists.forEach((element) async {
//     var cacheData2 = await APICacheManager().addCacheData(new APICacheDBModel(
//       syncData: '{"name":"lava$element"}',
//       key: "$element",
//     ));
//   });
//
//   List<Map<String,dynamic>> list = await APICacheDBHelper.query(APICacheDBModel.table);
//   // await APICacheDBHelper.rawQuery("select * from ${APICacheDBModel.table}");
//   // print(list);
//   list.forEach((element) {
//     print(element);
//   });
//   return list;
// }
late String url;
Future<Weather5Days> fetchWeatherForWeek() async {
  var currentLocationData = await location.getLocation();
  url = city!=""?'http://api.openweathermap.org/data/2.5/forecast?q=$city&cnt=40&appid=43ec70748cae1130be4146090de59761&units=metric':'http://api.openweathermap.org/data/2.5/forecast?lat=${currentLocationData.latitude}&lon=${currentLocationData.longitude}&cnt=40&appid=43ec70748cae1130be4146090de59761&units=metric';

  // Dio dio = Dio();
  // dio.interceptors.add(DioCacheManager(CacheConfig(baseUrl: "city!=""?'http://api.openweathermap.org/data/2.5/forecast?q=$city&cnt=40&appid=43ec70748cae1130be4146090de59761&units=metric':'http://api.openweathermap.org/data/2.5/forecast?lat=${currentLocationData.latitude}&lon=${currentLocationData.longitude}&cnt=40&appid=43ec70748cae1130be4146090de59761&units=metri")).interceptor);

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
    print("PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP");
    print(response.statusCode);
    print(rightCity);

    throw Exception('Error ${response.statusCode}');
  }
}