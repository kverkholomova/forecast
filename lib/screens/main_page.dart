import 'package:flutter/material.dart';
import 'package:forecast/screens/home_page.dart';
import 'package:forecast/screens/today_forecast.dart';
import 'package:google_fonts/google_fonts.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar:AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TabBar(
                unselectedLabelColor: Colors.black45,
                labelColor: Colors.indigoAccent.withOpacity(0.6),
                  indicatorColor: Colors.indigoAccent,
                onTap: (number) {
                  switch (number) {
                    case 0:
                      loading=true;
                      loading_today=true;
                      break;
                    case 1:
                      loading=true;
                      loading_today=true;
                      break;
                    default:
                      loading=true;
                      loading_today=true;
                  }
                },
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
            ],
          ),
        ),

        body: const TabBarView(
          children: [
            HomePageToday(),
            HomePage(),
          ],
        ),
      ),
    );
  }
}
