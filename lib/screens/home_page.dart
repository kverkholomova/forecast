import 'dart:async';
import 'dart:math';
import 'package:forecast/screens/main_page.dart';
import 'package:forecast/screens/today_forecast.dart';
import 'package:forecast/widgets/loader.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:forecast/models/weather_week_model.dart';
import 'package:forecast/screens/another_day_forecast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

import '../api/weather_week_api.dart';
import '../utils/location_functionality.dart';
import '../widgets/icons.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

bool loading = true;
int numDay = 0;

String dateWeekName = '';
int index = 0;
String iconNum = '';
String description = '';
bool today= true;
class _HomePageState extends State<HomePage> {
  late Future<Weather5Days> futureWeatherWeek;
  Random random = Random();



  weekDaysName(int dayCount) {
    DateTime dateWeek = DateTime.now().add(Duration(days: dayCount));
    return dateWeek;
  }

  void changeIndex() {
    setState(() => index = random.nextInt(5));
  }

  late VideoPlayerController _controller;

  late TextEditingController textEditingController;
  VideoPlayerController getController(String path) {
    _controller = VideoPlayerController.asset(path)
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
      });
    return _controller;
  }

  dataLoadFunction() async {
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {

    super.initState();
    futureWeatherWeek = fetchWeatherForWeek();
    Timer(const Duration(seconds: 4), () => dataLoadFunction());


    setState(() {
      textEditingController = TextEditingController();
      serviceEn();
      permissGranted();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading ? const Loader() : SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Padding(
            padding: EdgeInsets.only(top: MediaQuery
                .of(context)
                .size
                .width * 0.53,
                bottom: MediaQuery
                    .of(context)
                    .size
                    .width * 0.3),
            child: Align(
              alignment: Alignment.center,
              child: FittedBox(
                fit: BoxFit.fill,
                child: SizedBox(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.9,
                  height: MediaQuery
                      .of(context)
                      .size
                      .width * 0.9,
                  child: FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return VideoPlayer(controllerVideo(snapshot));
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }

                      // By default, show a loading spinner.
                      return Container();
                    },
                  ),
                ),
              ),
            ),
          ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery
                    .of(context)
                    .size
                    .height * 0.11,
                // bottom: MediaQuery.of(context).size.height * 0.02,
              ),
              child: SizedBox(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Stack(
                    children: [
                      buildTemperature(context),
                      buildDescription(context),
                      buildHumidity(context),
                      const HumidityIcon(),
                      const WindSpeedIcon(),
                      const WindKmH(),
                      buildWindSpeed(context),
                      buildCityName(context),
                      Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery
                              .of(context)
                              .size
                              .height * 0.19,
                        ),
                        child: Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              DateFormat('EEEE').format(weekDaysName(0)),
                              style: GoogleFonts.roboto(
                                fontSize: 26,
                                color: Colors.indigoAccent.withOpacity(0.7),
                              ),
                            )),
                      ),
                      buildDate(context),

                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.width*0.02),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  // width: MediaQuery.of(context).size.width*0.9,
                  height: MediaQuery.of(context).size.width*0.13,
                  color: Colors.white,
                  child: TextField(
                    textAlignVertical: TextAlignVertical.bottom,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(width: 0.5, color: Colors.black45),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.indigoAccent.withOpacity(0.7)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusColor: Colors.indigoAccent.withOpacity(0.7),
                        hintText: "Find your city",
                        hintStyle: GoogleFonts.roboto(
                          fontSize: 16,
                          color: Colors.black.withOpacity(0.3),
                        )
                    ),
                    controller: textEditingController,
                    onSubmitted: (String value) async {
                      city = value;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                            const MainPage()),
                      );
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery
                      .of(context)
                      .size
                      .height * 0.68),
              child: buildBottomWeatherWidget(context),
            ),
          ],
        ),
      ),
    );
  }

  Padding buildDate(BuildContext context) {
    return Padding(
              padding: EdgeInsets.only(
                top: MediaQuery
                    .of(context)
                    .size
                    .height * 0.23,
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: FutureBuilder<Weather5Days>(
                  future: futureWeatherWeek,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var tom =
                          "${snapshot.data?.commonList?[0]["dt_txt"]
                          .toString()
                          .substring(0, 4)}.${snapshot.data
                          ?.commonList?[0]["dt_txt"].toString().substring(
                          5, 7)}.${snapshot.data?.commonList?[0]["dt_txt"]
                          .toString()
                          .substring(8, 10)}";
                      return Text(
                        tom,
                        style: GoogleFonts.roboto(
                          fontSize: 13,
                          color: Colors.black45,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text(
                          '${snapshot.error}${snapshot.data?.commonList}');
                    }

                    return Container();
                  },
                ),
              ),
            );
  }

  Padding buildCityName(BuildContext context) {
    return Padding(
              padding: EdgeInsets.only(
                top: MediaQuery
                    .of(context)
                    .size
                    .height * 0,
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: FutureBuilder<Weather5Days>(
                  future: futureWeatherWeek,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var tom = "${snapshot.data?.city?.name}";
                      return Text(
                        tom,
                        style: GoogleFonts.roboto(
                          fontSize: 26,
                          color: Colors.black45,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text(
                          '${snapshot.error}${snapshot.data?.commonList}');
                    }

                    return Container();
                  },
                ),
              ),
            );
  }

  Padding buildWindSpeed(BuildContext context) {
    return Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery
                      .of(context)
                      .size
                      .height * 0.01,
                  right: MediaQuery
                      .of(context)
                      .size
                      .height * 0.057),
              child: Align(
                alignment: Alignment.topRight,
                child: FutureBuilder<Weather5Days>(
                  future: futureWeatherWeek,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var tom =
                          "${snapshot.data
                          ?.commonList?[0]["wind"]["speed"]}";
                      return Text(
                        tom,
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          color: Colors.black45,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text(
                          '${snapshot.error}${snapshot.data?.commonList}');
                    }
                    return Container();
                  },
                ),
              ),
            );
  }

  Padding buildHumidity(BuildContext context) {
    return Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery
                      .of(context)
                      .size
                      .height * 0.045,
                  // right: MediaQuery
                  //     .of(context)
                  //     .size
                  //     .height * 0.045
              ),
              child: Align(
                alignment: Alignment.topRight,
                child: FutureBuilder<Weather5Days>(
                  future: futureWeatherWeek,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var tom =
                          "${snapshot.data
                          ?.commonList?[0]["main"]["humidity"]} %";
                      return Text(
                        tom,
                        style: GoogleFonts.roboto(
                          fontSize: 20,
                          color: Colors.black45,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text(
                          '${snapshot.error}${snapshot.data?.commonList}');
                    }
                    return Container();
                  },
                ),
              ),
            );
  }

  Positioned buildDescription(BuildContext context) {
    return Positioned(
              top: MediaQuery
                  .of(context)
                  .size
                  .height * 0.15,
              // left: MediaQuery.of(context).size.height * 0.021,
              child: Align(
                alignment: Alignment.topLeft,
                child: FutureBuilder<Weather5Days>(
                  future: futureWeatherWeek,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var tom =
                          "${snapshot.data!
                          .commonList?[0]["weather"][0]["description"]}";
                      return Text(
                        tom,
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          color: Colors.black45,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text(
                          '${snapshot.error}${snapshot.data?.commonList}');
                    }

                    return Container();
                  },
                ),
              ),
            );
  }

  Padding buildTemperature(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery
              .of(context)
              .size
              .height * 0.035),
      child: Align(
        alignment: Alignment.topLeft,
        child: FutureBuilder<Weather5Days>(
          future: futureWeatherWeek,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var tom =
                  "${snapshot.data?.commonList?[0]["main"]["temp"]
                  ?.toInt()}\u2103";
              return Text(
                tom,
                style: GoogleFonts.openSans(
                  fontSize: 64,
                  color: Colors.indigoAccent.withOpacity(0.7),
                ),
              );
            } else if (snapshot.hasError) {
              return Text(
                  '${snapshot.error}${snapshot.data?.commonList}');
            }

            return Container();
          },
        ),
      ),
    );
  }

  VideoPlayerController controllerVideo(AsyncSnapshot<Weather5Days> snapshot) {
    return snapshot.data!.commonList![0]
                        ["weather"][0]["description"] ==
                            "clear sky"
                            ? getController("assets/sunny_day.mp4")
                            : snapshot.data!.commonList![0]
                        ["weather"][0]["description"] ==
                            "few clouds"
                            ? getController("assets/sunny.mp4")
                            : snapshot.data!.commonList![0]
                        ["weather"][0]["description"] ==
                            "scattered clouds"
                            ? getController("assets/windy_cloud.mp4")
                            : snapshot.data!.commonList![0]
                        ["weather"][0]["description"] ==
                            "broken clouds"
                            ? getController("assets/windy_cloud.mp4")
                            : snapshot.data!.commonList![0]
                        ["weather"][0]["description"] ==
                            "shower rain"
                            ? getController("assets/rainy_day.mp4")
                            : snapshot.data!.commonList![0]
                        ["weather"][0]["description"] ==
                            "light rain"
                            ? getController("assets/cloudy_rain.mp4")
                            : snapshot.data!.commonList![0]
                        ["weather"][0]["description"] ==
                            "thunderstorm"
                            ? getController("assets/thunder_rain.mp4")
                            : snapshot.data!.commonList![0]
                        ["weather"][0]["description"] ==
                            "snow"
                            ? getController("assets/snowfall.mp4")
                            : snapshot.data!.commonList![0]
                        ["weather"][0]["description"] == "overcast clouds"
                            ? getController("assets/windy_cloud.mp4")
                            : getController("assets/warm_wind.mp4");
  }

  SingleChildScrollView buildBottomWeatherWidget(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  today = false;
                  selectedIndex=1;
                  controllerTab.index = 1;
                  loadingToday = true;
                  loadingNew=true;

                  dateWeekName =
                      DateFormat('EEEE').format(weekDaysName(1));
                  numDay = 8;
                  changeIndex();
                });

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                      const MainPage()),
                );
              },
              child: Column(
                children: [
                  FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        description = snapshot.data!.commonList![8]
                        ["weather"][0]["description"];

                        var tom =
                            "${snapshot.data
                            ?.commonList?[8]["dt_txt"]
                            .toString()
                            .substring(5, 7)}.${snapshot.data
                            ?.commonList?[8]["dt_txt"]
                            .toString()
                            .substring(8, 11)}";
                        return Text(
                          tom,
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            color: Colors.black45,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                            '${snapshot.error}${snapshot.data
                                ?.commonList}');
                      }

                      return Container();
                    },
                  ),
                  FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.commonList?[8]["weather"][0]["icon"] ==
                            "01n"||snapshot.data!.commonList?[8]["weather"][0]["icon"] ==
                            "01d") {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Icon(
                              Icons.sunny,
                              size: 45,
                              color: Colors.black45,
                            ),
                          );
                        }
                        else {
                          return ImageIcon(
                            size: 60,
                            NetworkImage(
                              'http://openweathermap.org/img/wn/${snapshot
                                  .data!
                                  .commonList?[8]["weather"][0]["icon"]}@2x.png',
                            ),
                            color: Colors.black45,
                          );
                        }
                      } else if (snapshot.hasError) {
                        return Text(
                            '${snapshot.error}${snapshot.data
                                ?.commonList}');
                      }

                      return Container();
                    },
                  ),
                  Text(
                    DateFormat('EEEE').format(weekDaysName(1)),
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: Colors.black45,
                    ),
                  ),
                  FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var tom =
                            "${snapshot.data
                            ?.commonList?[8]["main"]["temp"]
                            ?.toInt()}\u2103";
                        return Text(
                          tom,
                          style: GoogleFonts.fredoka(
                            fontSize: 18,
                            color: Colors.black45,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                            '${snapshot.error}${snapshot.data
                                ?.commonList}');
                      }

                      return Container();
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () {
                setState(() {

                  today = false;
                  selectedIndex=1;
                  controllerTab.index = 1;
                  loadingNew=true;
                  loadingToday = true;
                  dateWeekName =
                      DateFormat('EEEE').format(weekDaysName(2));
                  numDay = 16;
                  changeIndex();
                });


                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                      const MainPage()),
                );
              },
              child: Column(
                children: [
                  FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        description = snapshot.data!.commonList![16]
                        ["weather"][0]["description"];
                        var tom =
                            "${snapshot.data
                            ?.commonList?[16]["dt_txt"]
                            .toString()
                            .substring(5, 7)}.${snapshot.data
                            ?.commonList?[16]["dt_txt"]
                            .toString()
                            .substring(8, 11)}";
                        return Text(
                          tom,
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            color: Colors.black45,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                            '${snapshot.error}${snapshot.data
                                ?.commonList}');
                      }

                      return Container();
                    },
                  ),
                  FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {

                        if (snapshot.data!.commonList?[16]["weather"][0]["icon"] ==
                            "01n"||snapshot.data!.commonList?[16]["weather"][0]["icon"] ==
                            "01d") {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Icon(
                              Icons.sunny,
                              size: 45,
                              color: Colors.black45,
                            ),
                          );
                        }
                        else {
                          return ImageIcon(
                            size: 60,
                            NetworkImage(
                              'http://openweathermap.org/img/wn/${snapshot
                                  .data!
                                  .commonList?[16]["weather"][0]["icon"]}@2x.png',
                            ),
                            color: Colors.black45,
                          );
                        }
                      } else if (snapshot.hasError) {
                        return Text(
                            '${snapshot.error}${snapshot.data
                                ?.commonList}');
                      }

                      return Container();
                    },
                  ),
                  Text(
                    DateFormat('EEEE').format(weekDaysName(2)),
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: Colors.black45,
                    ),
                  ),
                  FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var tom =
                            "${snapshot.data
                            ?.commonList?[16]["main"]["temp"]
                            ?.toInt()}\u2103";
                        return Text(
                          tom,
                          style: GoogleFonts.fredoka(
                            fontSize: 18,
                            color: Colors.black45,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                            '${snapshot.error}${snapshot.data
                                ?.commonList}');
                      }

                      return Container();
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  today = false;
                  selectedIndex=1;
                  controllerTab.index = 1;
                  loadingNew=true;
                  loadingToday = true;

                  dateWeekName =
                      DateFormat('EEEE').format(weekDaysName(3));
                  numDay = 24;
                  changeIndex();
                });

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                      const MainPage()),
                );
              },
              child: Column(
                children: [
                  FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        description = snapshot.data!.commonList![24]
                        ["weather"][0]["description"];
                        var tom =
                            "${snapshot.data
                            ?.commonList?[24]["dt_txt"]
                            .toString()
                            .substring(5, 7)}.${snapshot.data
                            ?.commonList?[24]["dt_txt"]
                            .toString()
                            .substring(8, 11)}";
                        return Text(
                          tom,
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            color: Colors.black45,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                            '${snapshot.error}${snapshot.data
                                ?.commonList}');
                      }

                      return Container();
                    },
                  ),
                  FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.commonList?[24]["weather"][0]["icon"]=="01n"||snapshot.data!.commonList?[24]["weather"][0]["icon"]=="01d"){
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Icon(
                              Icons.sunny,
                              size: 45,
                              color: Colors.black45,
                            ),
                          );
                        }
                        else{
                        return ImageIcon(
                          size: 60,
                          NetworkImage(
                            'http://openweathermap.org/img/wn/${snapshot
                                .data!
                                .commonList?[24]["weather"][0]["icon"]}@2x.png',
                          ),
                          color: Colors.black45,
                        );}
                      } else if (snapshot.hasError) {
                        return Text(
                            '${snapshot.error}${snapshot.data
                                ?.commonList}');
                      }

                      return Container();
                    },
                  ),
                  Text(
                    DateFormat('EEEE').format(weekDaysName(3)),
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: Colors.black45,
                    ),
                  ),
                  FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var tom =
                            "${snapshot.data
                            ?.commonList?[24]["main"]["temp"]
                            ?.toInt()}\u2103";
                        return Text(
                          tom,
                          style: GoogleFonts.fredoka(
                            fontSize: 18,
                            color: Colors.black45,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                            '${snapshot.error}${snapshot.data
                                ?.commonList}');
                      }

                      return Container();
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  today = false;
                  selectedIndex=1;
                  controllerTab.index = 1;
                  loadingNew=true;
                  loadingToday = true;
                  dateWeekName =
                      DateFormat('EEEE').format(weekDaysName(4));
                  numDay = 32;
                  changeIndex();
                });

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                      const MainPage()),
                );
              },
              child: Column(
                children: [
                  FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        description = snapshot.data!.commonList![32]
                        ["weather"][0]["description"];
                        var tom =
                            "${snapshot.data
                            ?.commonList?[32]["dt_txt"]
                            .toString()
                            .substring(5, 7)}.${snapshot.data
                            ?.commonList?[32]["dt_txt"]
                            .toString()
                            .substring(8, 11)}";
                        return Text(
                          tom,
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            color: Colors.black45,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                            '${snapshot.error}${snapshot.data
                                ?.commonList}');
                      }

                      return Container();
                    },
                  ),
                  FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.commonList?[32]["weather"][0]["icon"]=="01n"||snapshot.data!.commonList?[32]["weather"][0]["icon"]=="01d"){
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Icon(
                              Icons.sunny,
                              size: 45,
                              color: Colors.black45,
                            ),
                          );
                        }
                        else{
                        return ImageIcon(
                          size: 60,
                          NetworkImage(
                            'http://openweathermap.org/img/wn/${snapshot
                                .data!
                                .commonList?[32]["weather"][0]["icon"]}@2x.png',
                          ),
                          color: Colors.black45,
                        );}
                      } else if (snapshot.hasError) {
                        return Text(
                            '${snapshot.error}${snapshot.data
                                ?.commonList}');
                      }

                      return Container();
                    },
                  ),
                  Text(
                    DateFormat('EEEE').format(weekDaysName(4)),
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: Colors.black45,
                    ),
                  ),
                  FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var tom =
                            "${snapshot.data
                            ?.commonList?[32]["main"]["temp"]
                            ?.toInt()}\u2103";
                        return Text(
                          tom,
                          style: GoogleFonts.fredoka(
                            fontSize: 18,
                            color: Colors.black45,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                            '${snapshot.error}${snapshot.data
                                ?.commonList}');
                      }

                      return Container();
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  today = false;
                  selectedIndex=1;
                  controllerTab.index = 1;
                  loadingNew=true;
                  dateWeekName =
                      DateFormat('EEEE').format(weekDaysName(5));
                  numDay = 39;
                  changeIndex();
                  loadingToday = true;
                });

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                      const MainPage()),
                );
              },
              child: Column(
                children: [
                  FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        description = snapshot.data!.commonList![39]
                        ["weather"][0]["description"];
                        var tom =
                            "${snapshot.data
                            ?.commonList?[39]["dt_txt"]
                            .toString()
                            .substring(5, 7)}.${snapshot.data
                            ?.commonList?[39]["dt_txt"]
                            .toString()
                            .substring(8, 11)}";
                        return Text(
                          tom,
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            color: Colors.black45,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                            '${snapshot.error}${snapshot.data
                                ?.commonList}');
                      }

                      return Container();
                    },
                  ),
                  FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.commonList?[39]["weather"][0]["icon"]=="01n"||snapshot.data!.commonList?[39]["weather"][0]["icon"]=="01d"){
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Icon(
                              Icons.sunny,
                              size: 45,
                              color: Colors.black45,
                            ),
                          );
                        }
                        else{
                        return ImageIcon(
                          size: 60,
                          NetworkImage(
                            'http://openweathermap.org/img/wn/${snapshot
                                .data!
                                .commonList?[39]["weather"][0]["icon"]}@2x.png',
                          ),
                          color: Colors.black45,
                        );}
                      } else if (snapshot.hasError) {
                        return Text(
                            '${snapshot.error}${snapshot.data
                                ?.commonList}');
                      }

                      return Container();
                    },
                  ),
                  Text(
                    DateFormat('EEEE').format(weekDaysName(5)),
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: Colors.black45,
                    ),
                  ),
                  FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var tom =
                            "${snapshot.data
                            ?.commonList?[39]["main"]["temp"]
                            ?.toInt()}\u2103";
                        return Text(
                          tom,
                          style: GoogleFonts.fredoka(
                            fontSize: 18,
                            color: Colors.black45,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                            '${snapshot.error}${snapshot.data
                                ?.commonList}');
                      }

                      return Container();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


}

