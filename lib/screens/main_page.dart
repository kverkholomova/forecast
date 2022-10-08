import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:forecast/api/weather_week_api.dart';
import 'package:forecast/screens/another_day_forecast.dart';
import 'package:forecast/screens/exception_screen.dart';
import 'package:forecast/screens/home_page.dart';
import 'package:forecast/screens/today_forecast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/cache_manager.dart';

// Stream<FileResponse> fileStream = DefaultCacheManager().getFileStream(url);
Stream<FileResponse>? fileStream;
// Future<FileInfo?> fileInfoFuture= DefaultCacheManager().getFileFromCache('https://avatars1.githubusercontent.com/u/41328571?s=280&v=4');
class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}
// late TabController _controllerTab;
late TabController controllerTab;
int selectedIndex = 0;
class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  void _downloadFile() {
    setState(() {
      fileStream = DefaultCacheManager().getFileStream(url!, withProgress: true);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Create TabController for getting the index of current tab
    controllerTab = today&&hourly?TabController(length: 2, vsync: this,initialIndex: 0):today&&!hourly?TabController(length: 2, vsync: this, initialIndex: 1):TabController(length: 2, vsync: this, initialIndex: 1);
    controllerTab.addListener(() {
      setState(() {
        // fetchWeatherForWeek();
        selectedIndex = controllerTab.index;
        _downloadFile();

      });
print("TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT");
print(url);

    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future refresh() async{
    fetchWeatherForWeek();
    setState(() {

      print("VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV");
    });
  }

  @override
  Widget build(BuildContext context) {
    return !rightCity?const ExceptionScreen():DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
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
              Tab(icon: Text("5 Days", style: GoogleFonts.roboto(
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
              // DefaultCacheManager().getFileFromCache(url!=null?url.toString():'http://api.openweathermap.org/data/2.5/forecast?q=Slupsk&cnt=40&appid=43ec70748cae1130be4146090de59761&units=metric') == null? UploadCacheMemoryData(): FetchCacheMemoryData(),
              HomePageToday(),
              today?const HomePage():const AnotherDayForecast(),
            ],
          ),
        ),
      ),
    );
  }
}
