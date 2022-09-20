import 'dart:async';
import 'dart:math';
import 'package:forecast/widgets/loader.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:forecast/models/weather_week_model.dart';
import 'package:forecast/screens/another_day_forecast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:weather_icons/weather_icons.dart';

import '../api/weather_week_api.dart';
import '../constants.dart';
import '../utils/location_functionality.dart';
import 'home_page.dart';

class HomePageToday extends StatefulWidget {
  const HomePageToday({Key? key}) : super(key: key);

  @override
  State<HomePageToday> createState() => _HomePageTodayState();
}


int numDay = 0;
bool loading_today=true;
DateTime date = DateTime.now();
String dateFormat = DateFormat('EEEE').format(date);
String dateWeekName = '';
int index = 0;
String iconNum = '';
String description = '';

class _HomePageTodayState extends State<HomePageToday> {
  late Future<Weather5Days> futureWeatherWeek;
  Random random = Random();
  DateTime dateWeek = DateTime.now();


  weekDaysName(int dayCount) {
    dateWeek = dateWeek.add(Duration(days: dayCount));
    return dateWeek;
  }

  void changeIndex() {
    setState(() => index = random.nextInt(5));
  }

  late VideoPlayerController _controller;

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
      loading_today = false;
    });
  }

  @override
  void initState() {

    super.initState();
    futureWeatherWeek = fetchWeatherForWeek();
    Timer(const Duration(seconds: 4), () => dataLoadFunction());
    setState(() {
      serviceEn();
      permissGranted();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading_today ? Loader() : Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery
              .of(context)
              .size
              .height * 0.01,
          // bottom: MediaQuery.of(context).size.height * 0.02,
        ),
        child: SizedBox(
          height: double.infinity,
          child: Stack(
            children: [

              Align(
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: SizedBox(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 1,
                    height: MediaQuery
                        .of(context)
                        .size
                        .width * 1,
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
              buildTemperature(context),
              buildDescription(context),
              buildHumidity(context),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery
                        .of(context)
                        .size
                        .height * 0.13,
                    right: MediaQuery
                        .of(context)
                        .size
                        .height * 0.08),
                child: const Align(
                  alignment: Alignment.topRight,
                  child: Icon(
                    WeatherIcons.humidity,
                    color: Colors.black45,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery
                        .of(context)
                        .size
                        .height * 0.085,
                    right: MediaQuery
                        .of(context)
                        .size
                        .height * 0.13),
                child: const Align(
                  alignment: Alignment.topRight,
                  child: Icon(
                    WeatherIcons.cloudy_windy,
                    color: Colors.black45,
                    size: 20,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery
                        .of(context)
                        .size
                        .height * 0.1,
                    right: MediaQuery
                        .of(context)
                        .size
                        .height * 0.01),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    "km/h",
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: Colors.black45,
                    ),
                  ),
                ),
              ),
              buildWindSpeed(context),
              buildCityName(context),
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery
                      .of(context)
                      .size
                      .height * 0.2,
                ),
                child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      dateFormat,
                      style: GoogleFonts.roboto(
                        fontSize: 28,
                        color: Colors.indigoAccent.withOpacity(0.7),
                      ),
                    )),
              ),
              buildDate(context),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery
                        .of(context)
                        .size
                        .height * 0.65),
                child: buildBottomWeatherWidget(context),
              ),
            ],
          ),
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
                    .height * 0.25,
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: FutureBuilder<Weather5Days>(
                  future: futureWeatherWeek,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var tom =
                          "${snapshot.data
                          ?.commonList?[0]["dt_txt"]
                          .toString().substring(11,16)}";
                      return Text(
                        tom,
                        style: GoogleFonts.roboto(
                          fontSize: 14,
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var tom = "${snapshot.data?.city?.name}";
                        return Text(
                          tom,
                          style: GoogleFonts.roboto(
                            fontSize: 28,
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
              ),
            );
  }

  Padding buildWindSpeed(BuildContext context) {
    return Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery
                      .of(context)
                      .size
                      .height * 0.09,
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
                      .height * 0.137,
                  right: MediaQuery
                      .of(context)
                      .size
                      .height * 0.025),
              child: Align(
                alignment: Alignment.topRight,
                child: FutureBuilder<Weather5Days>(
                  future: futureWeatherWeek,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var tom =
                          "${snapshot.data
                          ?.commonList?[0]["main"]["humidity"]}";
                      return Text(
                        tom,
                        style: GoogleFonts.roboto(
                          fontSize: 24,
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
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
              ),
            );
  }

  Padding buildTemperature(BuildContext context) {
    return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Padding(
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
    // ["weather"][0]["description"].contains("rain")
    //     ? getController("assets/rainy_day.mp4")
    //     : snapshot.data!.commonList![0]
    // ["weather"][0]["description"].contains("sun")
    //     ? getController("assets/sunny.mp4")
    //     : snapshot.data!.commonList![0]
    ["weather"][0]["description"] == "overcast clouds"
        ? getController("assets/windy_cloud.mp4")
        : getController("assets/warm_wind.mp4");
  }

  SingleChildScrollView buildBottomWeatherWidget(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
                children: [
                  FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {

                        var tom =
                            "${snapshot.data
                            ?.commonList?[1]["dt_txt"]
                            .toString().substring(11,16)}";
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
                        if (snapshot.data!.commonList?[1]["weather"][0]["icon"] ==
                            "01n"||snapshot.data!.commonList?[1]["weather"][0]["icon"] ==
                            "01d") {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
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
                                  .commonList?[1]["weather"][0]["icon"]}@2x.png',
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
                  FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var tom =
                            "${snapshot.data
                            ?.commonList?[1]["main"]["temp"]
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
                children: [
                  FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var tom =
                            "${snapshot.data
                            ?.commonList?[2]["dt_txt"]
                            .toString().substring(11,16)}";
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
                        if (snapshot.data!.commonList?[2]["weather"][0]["icon"] ==
                            "01n"||snapshot.data!.commonList?[2]["weather"][0]["icon"] ==
                            "01d") {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
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
                                  .commonList?[2]["weather"][0]["icon"]}@2x.png',
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
                  FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var tom =
                            "${snapshot.data
                            ?.commonList?[2]["main"]["temp"]
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
                children: [
                  FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var tom =
                            "${snapshot.data
                            ?.commonList?[3]["dt_txt"]
                            .toString().substring(11,16)}";
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
                        if (snapshot.data!.commonList?[3]["weather"][0]["icon"]=="01n"||snapshot.data!.commonList?[3]["weather"][0]["icon"]=="01d"){
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
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
                                  .commonList?[3]["weather"][0]["icon"]}@2x.png',
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
                  FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var tom =
                            "${snapshot.data
                            ?.commonList?[3]["main"]["temp"]
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
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
                            ?.commonList?[4]["dt_txt"]
                            .toString().substring(11,16)}";
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
                        if (snapshot.data!.commonList?[4]["weather"][0]["icon"]=="01n"||snapshot.data!.commonList?[4]["weather"][0]["icon"]=="01d"){
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
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
                                  .commonList?[4]["weather"][0]["icon"]}@2x.png',
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
                  FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var tom =
                            "${snapshot.data
                            ?.commonList?[4]["main"]["temp"]
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
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
                            ?.commonList?[5]["dt_txt"]
                            .toString().substring(11,16)}";
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
                        if (snapshot.data!.commonList?[5]["weather"][0]["icon"]=="01n"||snapshot.data!.commonList?[5]["weather"][0]["icon"]=="01d"){
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
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
                                  .commonList?[5]["weather"][0]["icon"]}@2x.png',
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
                  FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var tom =
                            "${snapshot.data
                            ?.commonList?[5]["main"]["temp"]
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
                children: [
                  FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {

                        var tom =
                            "${snapshot.data
                            ?.commonList?[6]["dt_txt"]
                            .toString().substring(11,16)}";
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
                        if (snapshot.data!.commonList?[6]["weather"][0]["icon"]=="01n"||snapshot.data!.commonList?[6]["weather"][0]["icon"]=="01d"){
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
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
                                  .commonList?[6]["weather"][0]["icon"]}@2x.png',
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
                  FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var tom =
                            "${snapshot.data
                            ?.commonList?[6]["main"]["temp"]
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
                children: [
                  FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {

                        var tom =
                            "${snapshot.data
                            ?.commonList?[7]["dt_txt"]
                            .toString().substring(11,16)}";
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
                        if (snapshot.data!.commonList?[7]["weather"][0]["icon"]=="01n"||snapshot.data!.commonList?[7]["weather"][0]["icon"]=="01d"){
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
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
                                  .commonList?[7]["weather"][0]["icon"]}@2x.png',
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
                  FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var tom =
                            "${snapshot.data
                            ?.commonList?[7]["main"]["temp"]
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
                children: [
                  FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {

                        var tom =
                            "${snapshot.data
                            ?.commonList?[8]["dt_txt"]
                            .toString().substring(11,16)}";
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
                        if (snapshot.data!.commonList?[8]["weather"][0]["icon"]=="01n"||snapshot.data!.commonList?[8]["weather"][0]["icon"]=="01d"){
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
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
                                  .commonList?[8]["weather"][0]["icon"]}@2x.png',
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

        ],
      ),
    );
  }


}