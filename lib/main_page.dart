

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forecast/screens/another_day_forecast.dart';
import 'package:forecast/screens/home_page.dart';
import 'package:forecast/screens/today_forecast.dart';

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
          backgroundColor: Colors.white,
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TabBar(
                unselectedLabelColor: Colors.black45,
                labelColor: Colors.indigoAccent.withOpacity(0.6),
                  indicatorColor: Colors.indigoAccent,
                onTap: (int) {
                  switch (int) {
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

                    const Tab(icon: Text("Today")),
                    const Tab(icon: Text("5Days")),
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
