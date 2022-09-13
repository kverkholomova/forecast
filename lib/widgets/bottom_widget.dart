import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forecast/models/weather_week_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

import '../api/weather_week_api.dart';
import '../utils/location_functionality.dart';

class BottomWidget extends StatefulWidget {
  const BottomWidget({Key? key}) : super(key: key);

  @override
  State<BottomWidget> createState() => _BottomWidgetState();
}

class _BottomWidgetState extends State<BottomWidget> {
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

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.1,
          bottom: MediaQuery.of(context).size.height * 0.02,
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.17),
              child: FittedBox(
                fit: BoxFit.fill,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.width * 1,
                  child: FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        // print("OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO");
                        // print(snapshot.data!.description[0]["description"]);
                        return VideoPlayer(snapshot.data!.common_list?[0]
                                    ["weather"][0]["description"] ==
                                "overcast clouds"
                            ? _controller
                            : _controller1);

                        // return Text("${snapshot.data!.common_list?[0]["weather"][0]["description"]}");
                        // return VideoPlayer(_controller);
                      } else if (snapshot.hasError) {
                        print("PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP");
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
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: Expanded(
                  child: FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        print("DDDDDDDDDDDDDDDDDDDDDDDDDDD");
                        print(snapshot.data?.common_list?[0]);
                        var tom =
                            "${snapshot.data?.common_list?[0]["main"]["temp"]?.toInt()}\u2103";
                        return Text(
                          "$tom",
                          style: GoogleFonts.openSans(
                            fontSize: 64,
                            color: Colors.indigoAccent,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        print("ERRRRROOOOOOOOOOOOOOOOOORRRR");
                        return Text(
                            '${snapshot.error}${snapshot.data?.common_list}');
                      }
                      print("MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM");
                      print(snapshot.data!.city!.name);
                      return const CircularProgressIndicator();
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.12,
              // left: MediaQuery.of(context).size.height * 0.021,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Expanded(
                    child: FutureBuilder<Weather5Days>(
                      future: futureWeatherWeek,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          print("DDDDDDDDDDDDDDDDDDDDDDDDDDD");
                          print(snapshot.data?.common_list?[0]);
                          var tom =
                              "${snapshot.data!.common_list?[0]["weather"][0]["description"]}";
                          return Text(
                            "$tom",
                            style: GoogleFonts.roboto(
                              fontSize: 18,
                              color: Colors.black45,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          print("ERRRRROOOOOOOOOOOOOOOOOORRRR");
                          return Text(
                              '${snapshot.error}${snapshot.data?.common_list}');
                        }
                        print(
                            "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM");
                        print(snapshot.data!.city!.name);
                        return const CircularProgressIndicator();
                      },
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.035,
                  right: MediaQuery.of(context).size.height * 0.021),
              child: Align(
                alignment: Alignment.topRight,
                child: Expanded(
                  child: FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        print("DDDDDDDDDDDDDDDDDDDDDDDDDDD");
                        print(snapshot.data?.common_list?[0]);
                        var tom =
                            "${snapshot.data?.common_list?[0]["main"]["humidity"]}%";
                        return Text(
                          "$tom",
                          style: GoogleFonts.roboto(
                            fontSize: 24,
                            color: Colors.black45,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        print("ERRRRROOOOOOOOOOOOOOOOOORRRR");
                        return Text(
                            '${snapshot.error}${snapshot.data?.common_list}');
                      }
                      print("MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM");
                      print(snapshot.data!.city!.name);
                      return const CircularProgressIndicator();
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.07,
                  right: MediaQuery.of(context).size.height * 0.021),
              child: Align(
                alignment: Alignment.topRight,
                child: Expanded(
                  child: FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        print("DDDDDDDDDDDDDDDDDDDDDDDDDDD");
                        print(snapshot.data?.common_list?[0]);
                        var tom =
                            "${snapshot.data?.common_list?[0]["wind"]["speed"]} km/h";
                        return Text(
                          "$tom",
                          style: GoogleFonts.roboto(
                            fontSize: 18,
                            color: Colors.black45,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        print("ERRRRROOOOOOOOOOOOOOOOOORRRR");
                        return Text(
                            '${snapshot.error}${snapshot.data?.common_list}');
                      }
                      print("MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM");
                      print(snapshot.data!.city!.name);
                      return const CircularProgressIndicator();
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.2,
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: Expanded(
                  child: FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        print("DDDDDDDDDDDDDDDDDDDDDDDDDDD");
                        print(snapshot.data?.common_list?[0]);
                        var tom =
                            "${snapshot.data?.city?.name}";
                        return Text(
                          "$tom",
                          style: GoogleFonts.roboto(
                            fontSize: 28,
                            color: Colors.black45,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        print("ERRRRROOOOOOOOOOOOOOOOOORRRR");
                        return Text(
                            '${snapshot.error}${snapshot.data?.common_list}');
                      }
                      print("MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM");
                      print(snapshot.data!.city!.name);
                      return const CircularProgressIndicator();
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.55,
              ),
              child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    "Tuesday",
                    style: GoogleFonts.roboto(
                      fontSize: 28,
                      color: Colors.black45,
                    ),
                  )),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.6,
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: Expanded(
                  child: FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        print("DDDDDDDDDDDDDDDDDDDDDDDDDDD");
                        print(snapshot.data?.common_list?[0]);
                        var tom =
                            "${snapshot.data?.common_list?[0]["dt_txt"].toString().substring(0,4)}.${snapshot.data?.common_list?[0]["dt_txt"].toString().substring(5,7)}.${snapshot.data?.common_list?[0]["dt_txt"].toString().substring(8,10)}";
                        return Text(
                          "$tom",
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            color: Colors.black45,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        print("ERRRRROOOOOOOOOOOOOOOOOORRRR");
                        return Text(
                            '${snapshot.error}${snapshot.data?.common_list}');
                      }
                      print("MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM");
                      print(snapshot.data!.city!.name);
                      return const CircularProgressIndicator();
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.7),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          Expanded(
                            child: FutureBuilder<Weather5Days>(
                              future: futureWeatherWeek,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  print("DDDDDDDDDDDDDDDDDDDDDDDDDDD");
                                  print(snapshot.data?.common_list?[0]);
                                  var tom =
                                      "${snapshot.data?.common_list?[8]["dt_txt"].toString().substring(5, 7)}.${snapshot.data?.common_list?[8]["dt_txt"].toString().substring(8, 11)}";
                                  return Text(
                                    "$tom",
                                    style: GoogleFonts.roboto(
                                      fontSize: 12,
                                      color: Colors.black45,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  print("ERRRRROOOOOOOOOOOOOOOOOORRRR");
                                  return Text(
                                      '${snapshot.error}${snapshot.data?.common_list}');
                                }
                                print(
                                    "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM");
                                print(snapshot.data!.city!.name);
                                return const CircularProgressIndicator();
                              },
                            ),
                          ),
                          // Text(
                          //   "09.09",
                          //   style: GoogleFonts.roboto(
                          //     fontSize: 12,
                          //     color: Colors.black45,
                          //   ),
                          // ),
                          Icon(
                            Icons.sunny,
                            color: Colors.black45,
                            size: 40,
                          ),
                          Text(
                            "Thursday",
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              color: Colors.black45,
                            ),
                          ),
                          Expanded(
                            child: FutureBuilder<Weather5Days>(
                              future: futureWeatherWeek,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  print("DDDDDDDDDDDDDDDDDDDDDDDDDDD");
                                  print(snapshot.data?.common_list?[0]);
                                  var tom =
                                      "${snapshot.data?.common_list?[8]["main"]["temp"]?.toInt()}\u2103";
                                  return Text(
                                    "$tom",
                                    style: GoogleFonts.fredoka(
                                      fontSize: 18,
                                      color: Colors.black45,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  print("ERRRRROOOOOOOOOOOOOOOOOORRRR");
                                  return Text(
                                      '${snapshot.error}${snapshot.data?.common_list}');
                                }
                                print(
                                    "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM");
                                print(snapshot.data!.city!.name);
                                return const CircularProgressIndicator();
                              },
                            ),
                          ),
                          // Text(
                          //   "18\u2103",
                          //   style: GoogleFonts.fredoka(
                          //     fontSize: 18,
                          //     color: Colors.black45,
                          //   ),
                          // )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          Expanded(
                            child: FutureBuilder<Weather5Days>(
                              future: futureWeatherWeek,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  print("DDDDDDDDDDDDDDDDDDDDDDDDDDD");
                                  print(snapshot.data?.common_list?[0]);
                                  var tom =
                                      "${snapshot.data?.common_list?[16]["dt_txt"].toString().substring(5, 7)}.${snapshot.data?.common_list?[16]["dt_txt"].toString().substring(8, 11)}";
                                  return Text(
                                    "$tom",
                                    style: GoogleFonts.roboto(
                                      fontSize: 12,
                                      color: Colors.black45,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  print("ERRRRROOOOOOOOOOOOOOOOOORRRR");
                                  return Text(
                                      '${snapshot.error}${snapshot.data?.common_list}');
                                }
                                print(
                                    "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM");
                                print(snapshot.data!.city!.name);
                                return const CircularProgressIndicator();
                              },
                            ),
                          ),
                          // Text(
                          //   "09.09",
                          //   style: GoogleFonts.roboto(
                          //     fontSize: 12,
                          //     color: Colors.black45,
                          //   ),
                          // ),
                          Icon(
                            Icons.sunny,
                            color: Colors.black45,
                            size: 40,
                          ),
                          Text(
                            "Thursday",
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              color: Colors.black45,
                            ),
                          ),
                          Expanded(
                            child: FutureBuilder<Weather5Days>(
                              future: futureWeatherWeek,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  print("DDDDDDDDDDDDDDDDDDDDDDDDDDD");
                                  print(snapshot.data?.common_list?[0]);
                                  var tom =
                                      "${snapshot.data?.common_list?[16]["main"]["temp"]?.toInt()}\u2103";
                                  return Text(
                                    tom,
                                    style: GoogleFonts.fredoka(
                                      fontSize: 18,
                                      color: Colors.black45,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  print("ERRRRROOOOOOOOOOOOOOOOOORRRR");
                                  return Text(
                                      '${snapshot.error}${snapshot.data?.common_list}');
                                }
                                print(
                                    "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM");
                                print(snapshot.data!.city!.name);
                                return const CircularProgressIndicator();
                              },
                            ),
                          ),
                          // Text(
                          //   "18\u2103",
                          //   style: GoogleFonts.fredoka(
                          //     fontSize: 18,
                          //     color: Colors.black45,
                          //   ),
                          // )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          Expanded(
                            child: FutureBuilder<Weather5Days>(
                              future: futureWeatherWeek,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  print("DDDDDDDDDDDDDDDDDDDDDDDDDDD");
                                  print(snapshot.data?.common_list?[0]);
                                  var tom =
                                      "${snapshot.data?.common_list?[24]["dt_txt"].toString().substring(5, 7)}.${snapshot.data?.common_list?[24]["dt_txt"].toString().substring(8, 11)}";
                                  return Text(
                                    "$tom",
                                    style: GoogleFonts.roboto(
                                      fontSize: 12,
                                      color: Colors.black45,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  print("ERRRRROOOOOOOOOOOOOOOOOORRRR");
                                  return Text(
                                      '${snapshot.error}${snapshot.data?.common_list}');
                                }
                                print(
                                    "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM");
                                print(snapshot.data!.city!.name);
                                return const CircularProgressIndicator();
                              },
                            ),
                          ),
                          // Text(
                          //   "09.09",
                          //   style: GoogleFonts.roboto(
                          //     fontSize: 12,
                          //     color: Colors.black45,
                          //   ),
                          // ),
                          Icon(
                            Icons.sunny,
                            color: Colors.black45,
                            size: 40,
                          ),
                          Text(
                            "Thursday",
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              color: Colors.black45,
                            ),
                          ),
                          Expanded(
                            child: FutureBuilder<Weather5Days>(
                              future: futureWeatherWeek,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  print("DDDDDDDDDDDDDDDDDDDDDDDDDDD");
                                  print(snapshot.data?.common_list?[0]);
                                  var tom =
                                      "${snapshot.data?.common_list?[24]["main"]["temp"]?.toInt()}\u2103";
                                  return Text(
                                    tom,
                                    style: GoogleFonts.fredoka(
                                      fontSize: 18,
                                      color: Colors.black45,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  print("ERRRRROOOOOOOOOOOOOOOOOORRRR");
                                  return Text(
                                      '${snapshot.error}${snapshot.data?.common_list}');
                                }
                                print(
                                    "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM");
                                print(snapshot.data!.city!.name);
                                return const CircularProgressIndicator();
                              },
                            ),
                          ),
                          // Text(
                          //   "18\u2103",
                          //   style: GoogleFonts.fredoka(
                          //     fontSize: 18,
                          //     color: Colors.black45,
                          //   ),
                          // )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          Expanded(
                            child: FutureBuilder<Weather5Days>(
                              future: futureWeatherWeek,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  print("DDDDDDDDDDDDDDDDDDDDDDDDDDD");
                                  print(snapshot.data?.common_list?[0]);
                                  var tom =
                                      "${snapshot.data?.common_list?[32]["dt_txt"].toString().substring(5, 7)}.${snapshot.data?.common_list?[32]["dt_txt"].toString().substring(8, 11)}";
                                  return Text(
                                    "$tom",
                                    style: GoogleFonts.roboto(
                                      fontSize: 12,
                                      color: Colors.black45,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  print("ERRRRROOOOOOOOOOOOOOOOOORRRR");
                                  return Text(
                                      '${snapshot.error}${snapshot.data?.common_list}');
                                }
                                print(
                                    "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM");
                                print(snapshot.data!.city!.name);
                                return const CircularProgressIndicator();
                              },
                            ),
                          ),
                          // Text(
                          //   "09.09",
                          //   style: GoogleFonts.roboto(
                          //     fontSize: 12,
                          //     color: Colors.black45,
                          //   ),
                          // ),
                          Icon(
                            Icons.sunny,
                            color: Colors.black45,
                            size: 40,
                          ),
                          Text(
                            "Thursday",
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              color: Colors.black45,
                            ),
                          ),
                          Expanded(
                            child: FutureBuilder<Weather5Days>(
                              future: futureWeatherWeek,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  print("DDDDDDDDDDDDDDDDDDDDDDDDDDD");
                                  print(snapshot.data?.common_list?[0]);
                                  var tom =
                                      "${snapshot.data?.common_list?[32]["main"]["temp"]?.toInt()}\u2103";
                                  return Text(
                                    tom,
                                    style: GoogleFonts.fredoka(
                                      fontSize: 18,
                                      color: Colors.black45,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  print("ERRRRROOOOOOOOOOOOOOOOOORRRR");
                                  return Text(
                                      '${snapshot.error}${snapshot.data?.common_list}');
                                }
                                print(
                                    "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM");
                                print(snapshot.data!.city!.name);
                                return const CircularProgressIndicator();
                              },
                            ),
                          ),
                          // Text(
                          //   "18\u2103",
                          //   style: GoogleFonts.fredoka(
                          //     fontSize: 18,
                          //     color: Colors.black45,
                          //   ),
                          // )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          Expanded(
                            child: FutureBuilder<Weather5Days>(
                              future: futureWeatherWeek,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  print("DDDDDDDDDDDDDDDDDDDDDDDDDDD");
                                  print(snapshot.data?.common_list?[0]);
                                  var tom =
                                      "${snapshot.data?.common_list?[39]["dt_txt"].toString().substring(5, 7)}.${snapshot.data?.common_list?[39]["dt_txt"].toString().substring(8, 11)}";
                                  return Text(
                                    "$tom",
                                    style: GoogleFonts.roboto(
                                      fontSize: 12,
                                      color: Colors.black45,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  print("ERRRRROOOOOOOOOOOOOOOOOORRRR");
                                  return Text(
                                      '${snapshot.error}${snapshot.data?.common_list}');
                                }
                                print(
                                    "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM");
                                print(snapshot.data!.city!.name);
                                return const CircularProgressIndicator();
                              },
                            ),
                          ),
                          // Text(
                          //   "09.09",
                          //   style: GoogleFonts.roboto(
                          //     fontSize: 12,
                          //     color: Colors.black45,
                          //   ),
                          // ),
                          Icon(
                            Icons.sunny,
                            color: Colors.black45,
                            size: 40,
                          ),
                          Text(
                            "Thursday",
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              color: Colors.black45,
                            ),
                          ),
                          Expanded(
                            child: FutureBuilder<Weather5Days>(
                              future: futureWeatherWeek,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  print("DDDDDDDDDDDDDDDDDDDDDDDDDDD");
                                  print(snapshot.data?.common_list?[0]);
                                  var tom =
                                      "${snapshot.data?.common_list?[39]["main"]["temp"]?.toInt()}\u2103";
                                  return Text(
                                    tom,
                                    style: GoogleFonts.fredoka(
                                      fontSize: 18,
                                      color: Colors.black45,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  print("ERRRRROOOOOOOOOOOOOOOOOORRRR");
                                  return Text(
                                      '${snapshot.error}${snapshot.data?.common_list}');
                                }
                                print(
                                    "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM");
                                print(snapshot.data!.city!.name);
                                return const CircularProgressIndicator();
                              },
                            ),
                          ),
                          // Text(
                          //   "18\u2103",
                          //   style: GoogleFonts.fredoka(
                          //     fontSize: 18,
                          //     color: Colors.black45,
                          //   ),
                          // )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
