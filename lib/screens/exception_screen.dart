import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:forecast/api/weather_week_api.dart';
import 'package:forecast/screens/today_forecast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'main_page.dart';

class ExceptionScreen extends StatefulWidget {
  const ExceptionScreen({Key? key}) : super(key: key);

  @override
  State<ExceptionScreen> createState() => _ExceptionScreenState();
}
bool loadingException = true;
class _ExceptionScreenState extends State<ExceptionScreen> {


  dataLoadFunction() async {
    setState(() {
      loadingException = false;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 2), () {
      dataLoadFunction();

    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          actions: [
            IconButton(onPressed: (){
              rightCity = true;
              loadingToday = true;
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MainPage()),
              );
            }, icon: const Icon(Icons.close, color: Colors.black45,))
          ],
        ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              width: 140,
              height: 140,
              child: Image.asset("assets/sad.jpg")),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Align(
              alignment: Alignment.center,
              child: Text("Sorry, but the name of a city is not appropriate",
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 22,
                  color: Colors.black.withOpacity(0.5),

                ),),
            ),
          ),
        ],
      ),
      ),
    );
  }
}
