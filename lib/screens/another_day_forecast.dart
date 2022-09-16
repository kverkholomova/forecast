import 'dart:math';

import 'package:flutter/material.dart';
import 'package:forecast/models/weather_week_model.dart';
import 'package:forecast/screens/home_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';
import 'package:weather_icons/weather_icons.dart';

import '../api/weather_week_api.dart';
import '../utils/location_functionality.dart';

class AnotherDayForecast extends StatefulWidget {
  const AnotherDayForecast({Key? key}) : super(key: key);

  @override
  State<AnotherDayForecast> createState() => _AnotherDayForecastState();
}

class _AnotherDayForecastState extends State<AnotherDayForecast> {
  late Future<Weather5Days> futureWeatherWeek;


  late VideoPlayerController _controller;

  late VideoPlayerController _controller1;

  @override
  void initState() {
    super.initState();
    futureWeatherWeek = fetchWeatherForWeek();
    _controller = VideoPlayerController.asset("assets/windy_cloud.mp4")
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
      });
    _controller1 = VideoPlayerController.asset("assets/rain.mp4")
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      });
    setState(() {
      serviceEn();
      permissGranted();
    });
  }
  Random random = Random();
  void changeIndex() {
    setState(() => index = random.nextInt(5));
  }

  DateTime dateWeek = DateTime.now();
  weekDaysName(int dayCount){
    dateWeek = dateWeek.add(Duration(days: dayCount));
    return dateWeek;
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
          top: MediaQuery.of(context).size.height * 0.1,
        ),

        child: SizedBox(
          height: double.infinity,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.17,horizontal: MediaQuery.of(context).size.height * 0.01),
                child: Align(
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.width * 1,
                      child: FutureBuilder<Weather5Days>(
                        future: futureWeatherWeek,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return VideoPlayer(snapshot.data!.common_list?[numDay]
                            ["weather"][0]["description"] ==
                                "overcast clouds"
                                ? _controller
                                : _controller1);

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
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.035),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: FutureBuilder<Weather5Days>(
                      future: futureWeatherWeek,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {

                          var tom =
                              "${snapshot.data?.common_list?[numDay]["main"]["temp"]?.toInt()}\u2103";
                          return Text(
                            tom,
                            style: GoogleFonts.openSans(
                              fontSize: 64,
                              color: colors[index],
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text(
                              '${snapshot.error}${snapshot.data?.common_list}');
                        }
                        return const CircularProgressIndicator();
                      },
                    ),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.15,
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
                              "${snapshot.data!.common_list?[numDay]["weather"][0]["description"]}";
                          return Text(
                            tom,
                            style: GoogleFonts.roboto(
                              fontSize: 18,
                              color: Colors.black45,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text(
                              '${snapshot.error}${snapshot.data?.common_list}');
                        }
                        return const CircularProgressIndicator();
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.035,
                    right: MediaQuery.of(context).size.height * 0.03),
                child: Align(
                  alignment: Alignment.topRight,
                  child: FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {

                        var tom =
                            "${snapshot.data?.common_list?[numDay]["main"]["humidity"]}";
                        return Text(
                              tom,
                              style: GoogleFonts.roboto(
                                fontSize: 24,
                                color: Colors.black45,
                              ),
                            );


                      } else if (snapshot.hasError) {
                        return Text(
                            '${snapshot.error}${snapshot.data?.common_list}');
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.03,
                    right: MediaQuery.of(context).size.height * 0.08),
                child: const Align(
                  alignment: Alignment.topRight,
                  child: Icon(WeatherIcons.humidity,color: Colors.black45,),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.085,
                    right: MediaQuery.of(context).size.height * 0.13),
                child: const Align(
                  alignment: Alignment.topRight,
                  child: Icon(WeatherIcons.cloudy_windy,color: Colors.black45,size: 20,),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.09,
                    right: MediaQuery.of(context).size.height * 0.01),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text("km/h",
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: Colors.black45,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.09,
                    right: MediaQuery.of(context).size.height * 0.057),
                child: Align(
                  alignment: Alignment.topRight,
                  child: FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {

                        var tom =
                            "${snapshot.data?.common_list?[numDay]["wind"]["speed"]}";
                        return Text(
                          tom,
                          style: GoogleFonts.roboto(
                            fontSize: 18,
                            color: Colors.black45,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                            '${snapshot.error}${snapshot.data?.common_list}');
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0,
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: FutureBuilder<Weather5Days>(
                      future: futureWeatherWeek,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {

                          var tom =
                              "${snapshot.data?.city?.name}";
                          return Text(
                            tom,
                            style: GoogleFonts.roboto(
                              fontSize: 28,
                              color: Colors.black45,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text(
                              '${snapshot.error}${snapshot.data?.common_list}');
                        }
                        return const CircularProgressIndicator();
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.22,
                ),
                child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      dateWeekName,
                      style: GoogleFonts.roboto(
                        fontSize: 28,
                        color: colors[index],
                      ),
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.55,
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {

                        var tom =
                            "${snapshot.data?.common_list?[numDay]["dt_txt"].toString().substring(0,4)}.${snapshot.data?.common_list?[numDay]["dt_txt"].toString().substring(5,7)}.${snapshot.data?.common_list?[numDay]["dt_txt"].toString().substring(8,10)}";
                        return Text(
                          tom,
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            color: Colors.black45,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                            '${snapshot.error}${snapshot.data?.common_list}');
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.65),
                child: buildBottomWeather(context),
              ),
            ],
          ),
        ),

      ),
    );
  }

  SingleChildScrollView buildBottomWeather(BuildContext context) {
    return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    MaterialButton(
                      onPressed: (){
                        numDay = 8;
                        changeIndex();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const HomePage()),
                        );
                      },
                      child: Column(
                        children: [
                          FutureBuilder<Weather5Days>(
                            future: futureWeatherWeek,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                iconNum =  snapshot.data!.common_list?[0]["weather"][0]["icon"];
                                var tom =
                                    "${snapshot.data?.common_list?[0]["dt_txt"].toString().substring(5, 7)}.${snapshot.data?.common_list?[0]["dt_txt"].toString().substring(8, 11)}";
                                return Text(
                                  tom,
                                  style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    color: numDay==0?Colors.indigoAccent.withOpacity(0.7):Colors.black45,
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Text(
                                    '${snapshot.error}${snapshot.data?.common_list}');
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
                                    'http://openweathermap.org/img/wn/${snapshot.data!.common_list?[0]["weather"][0]["icon"]}@2x.png',
                                  ),

                                  color: numDay==0?colors[index]:Colors.black45,
                                );

                              } else if (snapshot.hasError) {
                                return Text(
                                    '${snapshot.error}${snapshot.data?.common_list}');
                              }

                              return const CircularProgressIndicator();
                            },
                          ),
                          Text(
                            DateFormat('EEEE').format(weekDaysName(0)),
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              color: numDay==0?Colors.indigoAccent.withOpacity(0.7):Colors.black45,
                            ),
                          ),
                          FutureBuilder<Weather5Days>(
                            future: futureWeatherWeek,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {

                                var tom =
                                    "${snapshot.data?.common_list?[0]["main"]["temp"]?.toInt()}\u2103";
                                return Text(
                                  tom,
                                  style: GoogleFonts.fredoka(
                                    fontSize: 18,
                                    color: numDay==0?Colors.indigoAccent.withOpacity(0.7):Colors.black45,
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Text(
                                    '${snapshot.error}${snapshot.data?.common_list}');
                              }

                              return const CircularProgressIndicator();
                            },
                          ),

                        ],
                      ),

                    ),
                    MaterialButton(
                      onPressed: (){
                        numDay = 8;
                        changeIndex();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AnotherDayForecast()),
                        );
                      },
                      child: Column(
                        children: [
                          FutureBuilder<Weather5Days>(
                            future: futureWeatherWeek,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                var tom =
                                    "${snapshot.data?.common_list?[8]["dt_txt"].toString().substring(5, 7)}.${snapshot.data?.common_list?[8]["dt_txt"].toString().substring(8, 11)}";
                                return Text(
                                  tom,
                                  style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    color: numDay==8?colors[index]:Colors.black45,
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Text(
                                    '${snapshot.error}${snapshot.data?.common_list}');
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
                                    'http://openweathermap.org/img/wn/${snapshot.data!.common_list?[8]["weather"][0]["icon"]}@2x.png',
                                  ),
                                  color: numDay==8?colors[index]:Colors.black45,
                                );

                              } else if (snapshot.hasError) {
                                return Text(
                                    '${snapshot.error}${snapshot.data?.common_list}');
                              }

                              return const CircularProgressIndicator();
                            },
                          ),
                          Text(
                            DateFormat('EEEE').format(weekDaysName(1)),
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              color: numDay==8?colors[index]:Colors.black45,
                            ),
                          ),
                          FutureBuilder<Weather5Days>(
                            future: futureWeatherWeek,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {

                                var tom =
                                    "${snapshot.data?.common_list?[8]["main"]["temp"]?.toInt()}\u2103";
                                return Text(
                                  tom,
                                  style: GoogleFonts.fredoka(
                                    fontSize: 18,
                                    color: numDay==8?colors[index]:Colors.black45,
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Text(
                                    '${snapshot.error}${snapshot.data?.common_list}');
                              }

                              return const CircularProgressIndicator();
                            },
                          ),

                        ],
                      ),

                    ),
                    MaterialButton(
                      onPressed: (){
                        numDay = 16;
                        changeIndex();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AnotherDayForecast()),
                        );
                      },
                      child: Column(
                        children: [
                          FutureBuilder<Weather5Days>(
                            future: futureWeatherWeek,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {

                                var tom =
                                    "${snapshot.data?.common_list?[16]["dt_txt"].toString().substring(5, 7)}.${snapshot.data?.common_list?[16]["dt_txt"].toString().substring(8, 11)}";
                                return Text(
                                  tom,
                                  style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    color: numDay==16?colors[index]:Colors.black45,
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Text(
                                    '${snapshot.error}${snapshot.data?.common_list}');
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
                                    'http://openweathermap.org/img/wn/${snapshot.data!.common_list?[16]["weather"][0]["icon"]}@2x.png',
                                  ),
                                  color: numDay==16?colors[index]:Colors.black45,
                                );

                              } else if (snapshot.hasError) {
                                return Text(
                                    '${snapshot.error}${snapshot.data?.common_list}');
                              }

                              return const CircularProgressIndicator();
                            },
                          ),

                          Text(
                            DateFormat('EEEE').format(weekDaysName(2)),
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              color: numDay==16?colors[index]:Colors.black45,
                            ),
                          ),
                          FutureBuilder<Weather5Days>(
                            future: futureWeatherWeek,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {

                                var tom =
                                    "${snapshot.data?.common_list?[16]["main"]["temp"]?.toInt()}\u2103";
                                return Text(
                                  tom,
                                  style: GoogleFonts.fredoka(
                                    fontSize: 18,
                                    color: numDay==16?colors[index]:Colors.black45,
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Text(
                                    '${snapshot.error}${snapshot.data?.common_list}');
                              }

                              return const CircularProgressIndicator();
                            },
                          ),

                        ],
                      ),
                    ),
                    MaterialButton(
                      onPressed: (){
                        numDay = 24;
                        changeIndex();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AnotherDayForecast()),
                        );
                      },
                      child: Column(
                        children: [
                          FutureBuilder<Weather5Days>(
                            future: futureWeatherWeek,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {

                                var tom =
                                    "${snapshot.data?.common_list?[24]["dt_txt"].toString().substring(5, 7)}.${snapshot.data?.common_list?[24]["dt_txt"].toString().substring(8, 11)}";
                                return Text(
                                  tom,
                                  style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    color: numDay==24?colors[index]:Colors.black45,
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Text(
                                    '${snapshot.error}${snapshot.data?.common_list}');
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
                                    'http://openweathermap.org/img/wn/${snapshot.data!.common_list?[24]["weather"][0]["icon"]}@2x.png',
                                  ),
                                  color: numDay==24?colors[index]:Colors.black45,
                                );

                              } else if (snapshot.hasError) {
                                return Text(
                                    '${snapshot.error}${snapshot.data?.common_list}');
                              }

                              return const CircularProgressIndicator();
                            },
                          ),
                          Text(
                            DateFormat('EEEE').format(weekDaysName(3)),
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              color: numDay==24?colors[index]:Colors.black45,
                            ),
                          ),
                          FutureBuilder<Weather5Days>(
                            future: futureWeatherWeek,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {

                                var tom =
                                    "${snapshot.data?.common_list?[24]["main"]["temp"]?.toInt()}\u2103";
                                return Text(
                                  tom,
                                  style: GoogleFonts.fredoka(
                                    fontSize: 18,
                                    color: numDay==24?colors[index]:Colors.black45,
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Text(
                                    '${snapshot.error}${snapshot.data?.common_list}');
                              }

                              return const CircularProgressIndicator();
                            },
                          ),

                        ],
                      ),
                    ),
                    MaterialButton(
                      onPressed: (){
                        numDay = 32;
                        changeIndex();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AnotherDayForecast()),
                        );
                      },
                      child: Column(
                        children: [
                          FutureBuilder<Weather5Days>(
                            future: futureWeatherWeek,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {

                                var tom =
                                    "${snapshot.data?.common_list?[32]["dt_txt"].toString().substring(5, 7)}.${snapshot.data?.common_list?[32]["dt_txt"].toString().substring(8, 11)}";
                                return Text(
                                  tom,
                                  style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    color: numDay==32?colors[index]:Colors.black45,
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Text(
                                    '${snapshot.error}${snapshot.data?.common_list}');
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
                                    'http://openweathermap.org/img/wn/${snapshot.data!.common_list?[32]["weather"][0]["icon"]}@2x.png',
                                  ),
                                  color: numDay==32?colors[index]:Colors.black45,
                                );

                              } else if (snapshot.hasError) {
                                return Text(
                                    '${snapshot.error}${snapshot.data?.common_list}');
                              }

                              return const CircularProgressIndicator();
                            },
                          ),
                          Text(
                            DateFormat('EEEE').format(weekDaysName(4)),
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              color: numDay==32?colors[index]:Colors.black45,
                            ),
                          ),
                          FutureBuilder<Weather5Days>(
                            future: futureWeatherWeek,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {

                                var tom =
                                    "${snapshot.data?.common_list?[32]["main"]["temp"]?.toInt()}\u2103";
                                return Text(
                                  tom,
                                  style: GoogleFonts.fredoka(
                                    fontSize: 18,
                                    color: numDay==32?colors[index]:Colors.black45,
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Text(
                                    '${snapshot.error}${snapshot.data?.common_list}');
                              }

                              return const CircularProgressIndicator();
                            },
                          ),

                        ],
                      ),
                    ),
                    MaterialButton(
                      onPressed: (){
                        numDay = 39;
                        changeIndex();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AnotherDayForecast()),
                        );
                      },
                      child: Column(
                        children: [
                          FutureBuilder<Weather5Days>(
                            future: futureWeatherWeek,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {

                                var tom =
                                    "${snapshot.data?.common_list?[39]["dt_txt"].toString().substring(5, 7)}.${snapshot.data?.common_list?[39]["dt_txt"].toString().substring(8, 11)}";
                                return Text(
                                  tom,
                                  style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    color: numDay==39?colors[index]:Colors.black45,
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Text(
                                    '${snapshot.error}${snapshot.data?.common_list}');
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
                                    'http://openweathermap.org/img/wn/${snapshot.data!.common_list?[39]["weather"][0]["icon"]}@2x.png',
                                  ),

                                  color: numDay==39?colors[index]:Colors.black45,
                                );

                              } else if (snapshot.hasError) {
                                return Text(
                                    '${snapshot.error}${snapshot.data?.common_list}');
                              }

                              return const CircularProgressIndicator();
                            },
                          ),
                          Text(
                            DateFormat('EEEE').format(weekDaysName(5)),
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              color: numDay==39?colors[index]:Colors.black45,
                            ),
                          ),
                          FutureBuilder<Weather5Days>(
                            future: futureWeatherWeek,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {

                                var tom =
                                    "${snapshot.data?.common_list?[39]["main"]["temp"]?.toInt()}\u2103";
                                return Text(
                                  tom,
                                  style: GoogleFonts.fredoka(
                                    fontSize: 18,
                                    color: numDay==39?colors[index]:Colors.black45,
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Text(
                                    '${snapshot.error}${snapshot.data?.common_list}');
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
}
