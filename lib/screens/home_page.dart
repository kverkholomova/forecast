import 'dart:math';
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

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

int numDay = 0;

DateTime date = DateTime.now();
String dateFormat = DateFormat('EEEE').format(date);
String dateWeekName = '';
int index = 0;
String iconNum = '';
String description='';
class _HomePageState extends State<HomePage> {
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
  @override
  void initState() {
    super.initState();
    futureWeatherWeek = fetchWeatherForWeek();
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery
              .of(context)
              .size
              .height * 0.1,
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
                          print("MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM");
                          print(snapshot.data!.commonList![0]
                          ["weather"][0]["description"].contains("cloud"));
                          return VideoPlayer(snapshot.data!.commonList![0]
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
                          ["weather"][0]["description"].contains("rain")
                              ? getController("assets/rainy_day.mp4")
                              : snapshot.data!.commonList![0]
                          ["weather"][0]["description"].contains("sun")
                              ? getController("assets/sunny.mp4")
                              : snapshot.data!.commonList![0]
                          ["weather"][0]["description"] =="overcast clouds"
                              ? getController("assets/clouds.mp4")
                              : getController("assets/warm_wind.mp4"));

                          // return Text("${snapshot.data!.common_list?[0]["weather"][0]["description"]}");
                          // return VideoPlayer(_controller);
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
              Padding(
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

                        return const CircularProgressIndicator();
                      },
                    ),
                  ),
                ),
              ),
              Positioned(
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

                        return const CircularProgressIndicator();
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
                        .height * 0.035,
                    right: MediaQuery
                        .of(context)
                        .size
                        .height * 0.03),
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
                      return const CircularProgressIndicator();
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery
                        .of(context)
                        .size
                        .height * 0.03,
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
                        .height * 0.09,
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
              Padding(
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
                      return const CircularProgressIndicator();
                    },
                  ),
                ),
              ),

              Padding(
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

                        return const CircularProgressIndicator();
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
                      .height * 0.22,
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
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery
                      .of(context)
                      .size
                      .height * 0.55,
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
                            fontSize: 14,
                            color: Colors.black45,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                            '${snapshot.error}${snapshot.data?.commonList}');
                      }

                      return const CircularProgressIndicator();
                    },
                  ),
                ),
              ),
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

  SingleChildScrollView buildBottomWeatherWidget(BuildContext context) {
    return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    MaterialButton(
                      onPressed: () {
                        print(description);
                        print("DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD");
                        dateWeekName =
                            DateFormat('EEEE').format(weekDaysName(1));
                        numDay = 8;
                        changeIndex();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                              const AnotherDayForecast()),
                        );
                      },
                      child: Column(
                        children: [
                          FutureBuilder<Weather5Days>(
                            future: futureWeatherWeek,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                description= snapshot.data!.commonList![8]
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

                              return const CircularProgressIndicator();
                            },
                          ),
                          FutureBuilder<Weather5Days>(
                            future: futureWeatherWeek,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ImageIcon(
                                  size: 60,
                                  NetworkImage(
                                    'http://openweathermap.org/img/wn/${snapshot
                                        .data!
                                        .commonList?[8]["weather"][0]["icon"]}@2x.png',
                                  ),
                                  color: numDay == 8
                                      ? colors[index]
                                      : Colors.black45,
                                );
                              } else if (snapshot.hasError) {
                                return Text(
                                    '${snapshot.error}${snapshot.data
                                        ?.commonList}');
                              }

                              return const CircularProgressIndicator();
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

                              return const CircularProgressIndicator();
                            },
                          ),
                        ],
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        dateWeekName =
                            DateFormat('EEEE').format(weekDaysName(2));
                        numDay = 16;
                        changeIndex();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                              const AnotherDayForecast()),
                        );
                      },
                      child: Column(
                        children: [
                          FutureBuilder<Weather5Days>(
                            future: futureWeatherWeek,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                description= snapshot.data!.commonList![16]
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

                              return const CircularProgressIndicator();
                            },
                          ),
                          FutureBuilder<Weather5Days>(
                            future: futureWeatherWeek,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ImageIcon(
                                  size: 60,
                                  NetworkImage(
                                    'http://openweathermap.org/img/wn/${snapshot
                                        .data!
                                        .commonList?[16]["weather"][0]["icon"]}@2x.png',
                                  ),
                                  color: Colors.black45,
                                );
                              } else if (snapshot.hasError) {
                                return Text(
                                    '${snapshot.error}${snapshot.data
                                        ?.commonList}');
                              }

                              return const CircularProgressIndicator();
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

                              return const CircularProgressIndicator();
                            },
                          ),
                        ],
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        print(description);
                        print("DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD");
                        dateWeekName =
                            DateFormat('EEEE').format(weekDaysName(3));
                        numDay = 24;
                        changeIndex();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                              const AnotherDayForecast()),
                        );
                      },
                      child: Column(
                        children: [
                          FutureBuilder<Weather5Days>(
                            future: futureWeatherWeek,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                description= snapshot.data!.commonList![24]
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

                              return const CircularProgressIndicator();
                            },
                          ),
                          FutureBuilder<Weather5Days>(
                            future: futureWeatherWeek,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ImageIcon(
                                  size: 60,
                                  NetworkImage(
                                    'http://openweathermap.org/img/wn/${snapshot
                                        .data!
                                        .commonList?[24]["weather"][0]["icon"]}@2x.png',
                                  ),
                                  color: Colors.black45,
                                );
                              } else if (snapshot.hasError) {
                                return Text(
                                    '${snapshot.error}${snapshot.data
                                        ?.commonList}');
                              }

                              return const CircularProgressIndicator();
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

                              return const CircularProgressIndicator();
                            },
                          ),
                        ],
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        dateWeekName =
                            DateFormat('EEEE').format(weekDaysName(4));
                        numDay = 32;
                        changeIndex();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                              const AnotherDayForecast()),
                        );
                      },
                      child: Column(
                        children: [
                          FutureBuilder<Weather5Days>(
                            future: futureWeatherWeek,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                description= snapshot.data!.commonList![32]
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

                              return const CircularProgressIndicator();
                            },
                          ),
                          FutureBuilder<Weather5Days>(
                            future: futureWeatherWeek,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ImageIcon(
                                  size: 60,
                                  NetworkImage(
                                    'http://openweathermap.org/img/wn/${snapshot
                                        .data!
                                        .commonList?[32]["weather"][0]["icon"]}@2x.png',
                                  ),
                                  color: Colors.black45,
                                );
                              } else if (snapshot.hasError) {
                                return Text(
                                    '${snapshot.error}${snapshot.data
                                        ?.commonList}');
                              }

                              return const CircularProgressIndicator();
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

                              return const CircularProgressIndicator();
                            },
                          ),
                        ],
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        dateWeekName =
                            DateFormat('EEEE').format(weekDaysName(5));
                        numDay = 39;
                        changeIndex();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                              const AnotherDayForecast()),
                        );
                      },
                      child: Column(
                        children: [
                          FutureBuilder<Weather5Days>(
                            future: futureWeatherWeek,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                description= snapshot.data!.commonList![39]
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

                              return const CircularProgressIndicator();
                            },
                          ),
                          FutureBuilder<Weather5Days>(
                            future: futureWeatherWeek,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ImageIcon(
                                  size: 60,
                                  NetworkImage(
                                    'http://openweathermap.org/img/wn/${snapshot
                                        .data!
                                        .commonList?[39]["weather"][0]["icon"]}@2x.png',
                                  ),
                                  color: Colors.black45,
                                );
                              } else if (snapshot.hasError) {
                                return Text(
                                    '${snapshot.error}${snapshot.data
                                        ?.commonList}');
                              }

                              return const CircularProgressIndicator();
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

                              return const CircularProgressIndicator();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
  }

  VideoPlayerController choseController(AsyncSnapshot<Weather5Days> snapshot) {
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
                        ["weather"][0]["description"].contains("rain")
                            ? getController("assets/rainy_day.mp4")
                            : snapshot.data!.commonList![0]
                        ["weather"][0]["description"].contains("sun")
                            ? getController("assets/sunny.mp4")
                            : snapshot.data!.commonList![0]
                        ["weather"][0]["description"] =="overcast clouds"
                            ? getController("assets/clouds.mp4")
                            : getController("assets/warm_wind.mp4");
  }
}
