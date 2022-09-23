import 'package:flutter/material.dart';

import '../api/weather_week_api.dart';
import '../models/weather_week_model.dart';
import '../screens/exception_screen.dart';
import '../screens/main_page.dart';

class Loader extends StatefulWidget {
  const Loader({Key? key}) : super(key: key);

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: Container(
            height: 70,
            width: 70,
            margin: const EdgeInsets.all(5),
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                color: Colors.indigoAccent.withOpacity(0.7),
              ),

          ),
        ),
      ),
    );
  }
}
