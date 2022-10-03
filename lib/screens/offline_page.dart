import 'dart:async';

import 'package:flutter/material.dart';
import 'package:forecast/api/weather_week_api.dart';
import 'package:forecast/screens/today_forecast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'main_page.dart';

class OfflineScreen extends StatefulWidget {
  const OfflineScreen({Key? key}) : super(key: key);

  @override
  State<OfflineScreen> createState() => _OfflineScreenState();
}
bool loadingException = true;
class _OfflineScreenState extends State<OfflineScreen> {


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
                child: Text("Sorry, but you are offline",
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