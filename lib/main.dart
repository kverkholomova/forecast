import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:forecast/screens/today_forecast.dart';

import 'app.dart';

void main() {
  runApp(const MyApp());
  CacheManager.logLevel = CacheManagerLogLevel.verbose;
}



