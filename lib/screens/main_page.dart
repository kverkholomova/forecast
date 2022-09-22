import 'dart:math';

import 'package:flutter/material.dart';
import 'package:forecast/screens/another_day_forecast.dart';
import 'package:forecast/screens/home_page.dart';
import 'package:forecast/screens/today_forecast.dart';
import 'package:google_fonts/google_fonts.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}
// late TabController _controllerTab;
late TabController controllerTab;
int selectedIndex = 0;
class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Create TabController for getting the index of current tab
    controllerTab = today&&hourly?TabController(length: 2, vsync: this,initialIndex: 0):today&&!hourly?TabController(length: 2, vsync: this, initialIndex: 1):TabController(length: 2, vsync: this, initialIndex: 1);
    controllerTab.addListener(() {
      setState(() {

        selectedIndex = controllerTab.index;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        bottomNavigationBar: Container(
          color: Colors.white,
          child: TabBar(
            // overlayColor: Colors.white,
            controller: controllerTab,
            unselectedLabelColor: Colors.black45,
            labelColor: Colors.indigoAccent.withOpacity(0.6),
            indicatorColor: Colors.indigoAccent,
            tabs: [
              Tab(icon: Text("Today", style: GoogleFonts.roboto(
                fontSize: 18,
                // color: Colors.indigoAccent.withOpacity(0.7),
              ),)),
              Tab(icon: Text("5Days", style: GoogleFonts.roboto(
                fontSize: 18,
                // color: Colors.indigoAccent.withOpacity(0.7),
              ),)),
            ],
          ),
        ),

        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: TabBarView(
            controller: controllerTab,
            children: [
              const HomePageToday(),
              today?const HomePage():const AnotherDayForecast(),
            ],
          ),
        ),
      ),
    );
  }
}
