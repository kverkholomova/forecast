import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:forecast/widgets/icons.dart';
import 'package:forecast/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:forecast/models/weather_week_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';

import '../api/weather_week_api.dart';
import '../utils/location_functionality.dart';
import 'home_page.dart';
import 'package:http/http.dart' as http;

import 'main_page.dart';


class HomePageToday extends StatefulWidget {
  const HomePageToday({Key? key}) : super(key: key);

  @override
  State<HomePageToday> createState() => _HomePageTodayState();
}
const kGoogleApiKey = "AIzaSyAQmVWIaI1Y97hjgwdyNcB5CX_kvyuzSZg";
String city = '';
bool hourly = true;
bool loadingToday = true;

class _HomePageTodayState extends State<HomePageToday> {
  late TextEditingController textEditingController;

  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  final searchScaffoldKey = GlobalKey<ScaffoldState>();
  late Future<Weather5Days> futureWeatherWeek;
  var uuid= const Uuid();
  Uuid _sessionToken = const Uuid();
  List<dynamic>_placeList = [];
  Random random = Random();
  DateTime dateWeek = DateTime.now();

  weekDaysName(int dayCount) {
    dateWeek = dateWeek.add(Duration(days: dayCount));
    return dateWeek;
  }

  void changeIndex() {
    setState(() => index = random.nextInt(5));
  }

  checkCityName()async{
    final responseName = await http.get(Uri.parse('http://api.openweathermap.org/data/2.5/forecast?q=$city&cnt=40&appid=43ec70748cae1130be4146090de59761&units=metric'));

    if (responseName.statusCode != 200){
      rightCity = false;
    }
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
      loadingToday = false;
    });
  }

  @override
  void initState() {
    super.initState();

    futureWeatherWeek = fetchWeatherForWeek();
    Timer(const Duration(seconds: 4), () {
      dataLoadFunction();

    });
    textEditingController = TextEditingController();

    textEditingController.addListener(() {
      _onChanged();
    });
    setState(() {
      serviceEn();
      permissGranted();
    });
  }

  void _onChanged() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4() as Uuid;
      });
    }
    getSuggestion(textEditingController.text);
  }
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    textEditingController.dispose();
  }

  // Future<String> showGoogleAutoComplete() async {
  //
  //   Prediction? p = await PlacesAutocomplete.show(
  //
  //       offset: 0,
  //       radius: 1000,
  //       strictbounds: false,
  //       region: "pl",
  //       language: "en",
  //       context: context,
  //       mode: Mode.overlay,
  //       apiKey: kGoogleApiKey,
  //       components: [Component(Component.country, "pl")],
  //       types: ["(cities)"],
  //       hint: "Search City",
  //       startText: city == null || city == "" ? "" : city,
  //   );
  //   return p!.description!;
  // }

  void getSuggestion(String input) async {
    String kPLACESAPIKEY = "AIzaSyAQmVWIaI1Y97hjgwdyNcB5CX_kvyuzSZg";
    String type = "(cities)";
    String baseURL ="https://maps.googleapis.com/maps/api/place/autocomplete/json";
    String request = "$baseURL?input=$input&key=$kPLACESAPIKEY&sessiontoken=$_sessionToken";
    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
    setState(() {
    _placeList = json.decode(response.body)['predictions'];
    });
    } else {
    throw Exception('Failed to load predictions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return loadingToday
        ? const Loader()
        : SafeArea(
            child: Scaffold(
              key: homeScaffoldKey,
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Stack(
                  children: [

                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.27,
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.width * 0.9,
                            child: FutureBuilder<Weather5Days>(
                              future: futureWeatherWeek,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return VideoPlayer(controllerVideo(snapshot));
                                } else if (snapshot.hasError) {
                                  return const Text("Error found");
                                }
                                return Container();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.11,
                        // bottom: MediaQuery.of(context).size.height * 0.02,
                      ),
                      child: Stack(
                        children: [
                          buildTemperature(context),
                          buildDescription(context),
                          Align(
                            alignment: Alignment.topRight,
                            child: SizedBox(
                              width: 100,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const HumidityIcon(),
                                  buildHumidity(context),
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: SizedBox(
                              width: 100,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const WindSpeedIcon(),
                                  buildWindSpeed(context),
                                  const WindKmH(),
                                ],
                              ),
                            ),
                          ),
                          buildCityName(context),
                          Padding(
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.19,
                            ),
                            child: Align(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  DateFormat('EEEE').format(weekDaysName(0)),
                                  style: GoogleFonts.roboto(
                                    fontSize: 24,
                                    color: Colors.indigoAccent.withOpacity(0.7),
                                  ),
                                )),
                          ),
                          buildDate(context),
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.7),
                      child: buildBottomWeatherWidget(context),
                    ),Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.width * 0.02),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          // width: MediaQuery.of(context).size.width*0.9,
                          // height: MediaQuery.of(context).size.width * 0.2,
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextField(
                                // readOnly: true,
                                // onTap: () async {
                                //
                                //   // city = await showGoogleAutoComplete();
                                //   // setState(() async {
                                //   //       loadingToday=true;
                                //   //       await checkCityName();
                                //   //       if (rightCity==true){
                                //   //         Navigator.push(
                                //   //             context,
                                //   //             MaterialPageRoute(
                                //   //                 builder: (context) => const MainPage()),
                                //   //           );
                                //   //       }
                                //   //       else{
                                //   //         city = "";
                                //   //         Navigator.push(
                                //   //           context,
                                //   //           MaterialPageRoute(
                                //   //               builder: (context) => const MainPage()),
                                //   //         );
                                //   //       }
                                //   //     });
                                // },
                                textAlignVertical: TextAlignVertical.bottom,
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 0.5, color: Colors.black45),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1,
                                          color:
                                          Colors.indigoAccent.withOpacity(0.7)),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    focusColor:
                                    Colors.indigoAccent.withOpacity(0.7),
                                    hintText: "Find your city",
                                    hintStyle: GoogleFonts.roboto(
                                      fontSize: 16,
                                      color: Colors.black.withOpacity(0.3),
                                    )),
                                controller: textEditingController,
                              onSubmitted: (String value) async {
                                  setState(() async {
                                    loading = true;
                                    city = value;
                                    await checkCityName();
                                    if (rightCity == true) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const MainPage()),
                                      );
                                    } else {
                                      city = "";
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const MainPage()),
                                      );
                                    }
                                  });
                                },
                              ),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: _placeList.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    contentPadding: EdgeInsets.only(top: 8, left: 5),
                                    minLeadingWidth: 10,
                                    horizontalTitleGap: 5,
                                    title: GestureDetector(
                                      onTap: ()async {
                                        print("JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ");
                                        print(_placeList[index]["description"]);
                                        city = await _placeList[index]["description"];

                                          loadingToday=true;
                                          await checkCityName();
                                          if (rightCity==true){
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => const MainPage()),
                                            );
                                          }
                                          else{
                                            city = "";
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => const MainPage()),
                                            );
                                          }

                                      },
                                      child: Row(
                                        children: [
                                            Padding(
                                              padding: const EdgeInsets.only(right: 7),
                                              child: Icon(Icons.location_on_outlined),
                                            ),
                                          Expanded(child: Text(_placeList[index]["description"])),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
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
        top: MediaQuery.of(context).size.height * 0.23,
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: FutureBuilder<Weather5Days>(
          future: futureWeatherWeek,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var tom =
                  "${snapshot.data?.commonList?[0]["dt_txt"].toString().substring(11, 16)}";
              return Text(
                tom,
                style: GoogleFonts.roboto(
                  fontSize: 13,
                  color: Colors.black45,
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}${snapshot.data?.commonList}');
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
        top: MediaQuery.of(context).size.height * 0,
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
              return Text('${snapshot.error}${snapshot.data?.commonList}');
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
        top: MediaQuery.of(context).size.height * 0.01,
        // right: MediaQuery
        //     .of(context)
        //     .size
        //     .height * 0.057
      ),
      child: Align(
        alignment: Alignment.topRight,
        child: FutureBuilder<Weather5Days>(
          future: futureWeatherWeek,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var tom = "${snapshot.data?.commonList?[0]["wind"]["speed"]}";
              return Text(
                tom,
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  color: Colors.black45,
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}${snapshot.data?.commonList}');
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
        top: MediaQuery.of(context).size.height * 0.045,
        right: MediaQuery
            .of(context)
            .size
            .height * 0.045
      ),
      child: Align(
        alignment: Alignment.topRight,
        child: FutureBuilder<Weather5Days>(
          future: futureWeatherWeek,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var tom =
                  "${snapshot.data?.commonList?[0]["main"]["humidity"]} %";
              return Text(
                tom,
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  color: Colors.black45,
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}${snapshot.data?.commonList}');
            }
            return Container();
          },
        ),
      ),
    );
  }

  Positioned buildDescription(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.15,
      // left: MediaQuery.of(context).size.height * 0.021,
      child: Align(
        alignment: Alignment.topLeft,
        child: FutureBuilder<Weather5Days>(
          future: futureWeatherWeek,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var tom =
                  "${snapshot.data!.commonList?[0]["weather"][0]["description"]}";
              return Text(
                tom,
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  color: Colors.black45,
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}${snapshot.data?.commonList}');
            }

            return Container();
          },
        ),
      ),
    );
  }

  Padding buildTemperature(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.035),
      child: Align(
        alignment: Alignment.topLeft,
        child: FutureBuilder<Weather5Days>(
          future: futureWeatherWeek,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var tom =
                  "${snapshot.data?.commonList?[0]["main"]["temp"]?.toInt()}\u2103";
              return Text(
                tom,
                style: GoogleFonts.openSans(
                  fontSize: 64,
                  color: Colors.indigoAccent.withOpacity(0.7),
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}${snapshot.data?.commonList}');
            }

            return Container();
          },
        ),
      ),
    );
  }

  VideoPlayerController controllerVideo(AsyncSnapshot<Weather5Days> snapshot) {
    return snapshot.data!.commonList![0]["weather"][0]["description"] ==
            "clear sky"
        ? getController("assets/sunny_day.mp4")
        : snapshot.data!.commonList![0]["weather"][0]["description"] ==
                "few clouds"
            ? getController("assets/sunny.mp4")
            : snapshot.data!.commonList![0]["weather"][0]["description"] ==
                    "scattered clouds"
                ? getController("assets/windy_cloud.mp4")
                : snapshot.data!.commonList![0]["weather"][0]["description"] ==
                        "broken clouds"
                    ? getController("assets/windy_cloud.mp4")
                    : snapshot.data!.commonList![0]["weather"][0]
                                ["description"] ==
                            "shower rain"
                        ? getController("assets/rainy_day.mp4")
                        : snapshot.data!.commonList![0]["weather"][0]
                                    ["description"] ==
                                "light rain"
                            ? getController("assets/cloudy_rain.mp4")
                            : snapshot.data!.commonList![0]["weather"][0]
                                        ["description"] ==
                                    "thunderstorm"
                                ? getController("assets/thunder_rain.mp4")
                                : snapshot.data!.commonList![0]["weather"][0]
                                            ["description"] ==
                                        "snow"
                                    ? getController("assets/snowfall.mp4")
                                    : snapshot.data!.commonList![0]
                                                // ["weather"][0]["description"].contains("rain")
                                                //     ? getController("assets/rainy_day.mp4")
                                                //     : snapshot.data!.commonList![0]
                                                // ["weather"][0]["description"].contains("sun")
                                                //     ? getController("assets/sunny.mp4")
                                                //     : snapshot.data!.commonList![0]
                                                ["weather"][0]["description"] ==
                                            "overcast clouds"
                                        ? getController(
                                            "assets/windy_cloud.mp4")
                                        : getController("assets/warm_wind.mp4");
  }

  SingleChildScrollView buildBottomWeatherWidget(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Column(
            children: [
              FutureBuilder<Weather5Days>(
                future: futureWeatherWeek,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var tom =
                        "${snapshot.data?.commonList?[1]["dt_txt"].toString().substring(11, 16)}";
                    return Text(
                      tom,
                      style: GoogleFonts.roboto(
                        fontSize: 12,
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
              FutureBuilder<Weather5Days>(
                future: futureWeatherWeek,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.commonList?[1]["weather"][0]["icon"] ==
                        "01d") {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: Icon(
                            Icons.sunny,
                            size: 45,
                            color: Colors.black45,
                          ),
                        ),
                      );
                    } else {
                      return ImageIcon(
                        size: 60,
                        NetworkImage(
                          'http://openweathermap.org/img/wn/${snapshot.data!.commonList?[1]["weather"][0]["icon"]}@2x.png',
                        ),
                        color: Colors.black45,
                      );
                    }
                  } else if (snapshot.hasError) {
                    return Text(
                        '${snapshot.error}${snapshot.data?.commonList}');
                  }

                  return Container();
                },
              ),
              FutureBuilder<Weather5Days>(
                future: futureWeatherWeek,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var tom =
                        "${snapshot.data?.commonList?[1]["main"]["temp"]?.toInt()}\u2103";
                    return Text(
                      tom,
                      style: GoogleFonts.fredoka(
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
            ],
          ),
          Column(
            children: [
              FutureBuilder<Weather5Days>(
                future: futureWeatherWeek,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var tom =
                        "${snapshot.data?.commonList?[2]["dt_txt"].toString().substring(11, 16)}";
                    return Text(
                      tom,
                      style: GoogleFonts.roboto(
                        fontSize: 12,
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
              FutureBuilder<Weather5Days>(
                future: futureWeatherWeek,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.commonList?[2]["weather"][0]["icon"] ==
                        "01d") {
                      return const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        child: Icon(
                          Icons.sunny,
                          size: 45,
                          color: Colors.black45,
                        ),
                      );
                    } else {
                      return ImageIcon(
                        size: 60,
                        NetworkImage(
                          'http://openweathermap.org/img/wn/${snapshot.data!.commonList?[2]["weather"][0]["icon"]}@2x.png',
                        ),
                        color: Colors.black45,
                      );
                    }
                  } else if (snapshot.hasError) {
                    return Text(
                        '${snapshot.error}${snapshot.data?.commonList}');
                  }

                  return Container();
                },
              ),
              FutureBuilder<Weather5Days>(
                future: futureWeatherWeek,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var tom =
                        "${snapshot.data?.commonList?[2]["main"]["temp"]?.toInt()}\u2103";
                    return Text(
                      tom,
                      style: GoogleFonts.fredoka(
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
            ],
          ),
          Column(
            children: [
              FutureBuilder<Weather5Days>(
                future: futureWeatherWeek,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var tom =
                        "${snapshot.data?.commonList?[3]["dt_txt"].toString().substring(11, 16)}";
                    return Text(
                      tom,
                      style: GoogleFonts.roboto(
                        fontSize: 12,
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
              FutureBuilder<Weather5Days>(
                future: futureWeatherWeek,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.commonList?[3]["weather"][0]["icon"] ==
                        "01d") {
                      return const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        child: Icon(
                          Icons.sunny,
                          size: 45,
                          color: Colors.black45,
                        ),
                      );
                    } else {
                      return ImageIcon(
                        size: 60,
                        NetworkImage(
                          'http://openweathermap.org/img/wn/${snapshot.data!.commonList?[3]["weather"][0]["icon"]}@2x.png',
                        ),
                        color: Colors.black45,
                      );
                    }
                  } else if (snapshot.hasError) {
                    return Text(
                        '${snapshot.error}${snapshot.data?.commonList}');
                  }

                  return Container();
                },
              ),
              FutureBuilder<Weather5Days>(
                future: futureWeatherWeek,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var tom =
                        "${snapshot.data?.commonList?[3]["main"]["temp"]?.toInt()}\u2103";
                    return Text(
                      tom,
                      style: GoogleFonts.fredoka(
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
            ],
          ),
          Column(
            children: [
              FutureBuilder<Weather5Days>(
                future: futureWeatherWeek,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    description = snapshot.data!.commonList![32]["weather"][0]
                        ["description"];
                    var tom =
                        "${snapshot.data?.commonList?[4]["dt_txt"].toString().substring(11, 16)}";
                    return Text(
                      tom,
                      style: GoogleFonts.roboto(
                        fontSize: 12,
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
              FutureBuilder<Weather5Days>(
                future: futureWeatherWeek,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.commonList?[4]["weather"][0]["icon"] ==
                        "01d") {
                      return const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        child: Icon(
                          Icons.sunny,
                          size: 45,
                          color: Colors.black45,
                        ),
                      );
                    } else {
                      return ImageIcon(
                        size: 60,
                        NetworkImage(
                          'http://openweathermap.org/img/wn/${snapshot.data!.commonList?[4]["weather"][0]["icon"]}@2x.png',
                        ),
                        color: Colors.black45,
                      );
                    }
                  } else if (snapshot.hasError) {
                    return Text(
                        '${snapshot.error}${snapshot.data?.commonList}');
                  }

                  return Container();
                },
              ),
              FutureBuilder<Weather5Days>(
                future: futureWeatherWeek,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var tom =
                        "${snapshot.data?.commonList?[4]["main"]["temp"]?.toInt()}\u2103";
                    return Text(
                      tom,
                      style: GoogleFonts.fredoka(
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
            ],
          ),
          Column(
            children: [
              FutureBuilder<Weather5Days>(
                future: futureWeatherWeek,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    description = snapshot.data!.commonList![39]["weather"][0]
                        ["description"];
                    var tom =
                        "${snapshot.data?.commonList?[5]["dt_txt"].toString().substring(11, 16)}";
                    return Text(
                      tom,
                      style: GoogleFonts.roboto(
                        fontSize: 12,
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
              FutureBuilder<Weather5Days>(
                future: futureWeatherWeek,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.commonList?[5]["weather"][0]["icon"] ==
                        "01d") {
                      return const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        child: Icon(
                          Icons.sunny,
                          size: 45,
                          color: Colors.black45,
                        ),
                      );
                    } else {
                      return ImageIcon(
                        size: 60,
                        NetworkImage(
                          'http://openweathermap.org/img/wn/${snapshot.data!.commonList?[5]["weather"][0]["icon"]}@2x.png',
                        ),
                        color: Colors.black45,
                      );
                    }
                  } else if (snapshot.hasError) {
                    return Text(
                        '${snapshot.error}${snapshot.data?.commonList}');
                  }

                  return Container();
                },
              ),
              FutureBuilder<Weather5Days>(
                future: futureWeatherWeek,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var tom =
                        "${snapshot.data?.commonList?[5]["main"]["temp"]?.toInt()}\u2103";
                    return Text(
                      tom,
                      style: GoogleFonts.fredoka(
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
            ],
          ),
          Column(
            children: [
              FutureBuilder<Weather5Days>(
                future: futureWeatherWeek,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var tom =
                        "${snapshot.data?.commonList?[6]["dt_txt"].toString().substring(11, 16)}";
                    return Text(
                      tom,
                      style: GoogleFonts.roboto(
                        fontSize: 12,
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
              FutureBuilder<Weather5Days>(
                future: futureWeatherWeek,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.commonList?[6]["weather"][0]["icon"] ==
                        "01d") {
                      return const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        child: Icon(
                          Icons.sunny,
                          size: 45,
                          color: Colors.black45,
                        ),
                      );
                    } else {
                      return ImageIcon(
                        size: 60,
                        NetworkImage(
                          'http://openweathermap.org/img/wn/${snapshot.data!.commonList?[6]["weather"][0]["icon"]}@2x.png',
                        ),
                        color: Colors.black45,
                      );
                    }
                  } else if (snapshot.hasError) {
                    return Text(
                        '${snapshot.error}${snapshot.data?.commonList}');
                  }

                  return Container();
                },
              ),
              FutureBuilder<Weather5Days>(
                future: futureWeatherWeek,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var tom =
                        "${snapshot.data?.commonList?[6]["main"]["temp"]?.toInt()}\u2103";
                    return Text(
                      tom,
                      style: GoogleFonts.fredoka(
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
            ],
          ),
          Column(
            children: [
              FutureBuilder<Weather5Days>(
                future: futureWeatherWeek,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var tom =
                        "${snapshot.data?.commonList?[7]["dt_txt"].toString().substring(11, 16)}";
                    return Text(
                      tom,
                      style: GoogleFonts.roboto(
                        fontSize: 12,
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
              FutureBuilder<Weather5Days>(
                future: futureWeatherWeek,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.commonList?[7]["weather"][0]["icon"] ==
                        "01d") {
                      return const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        child: Icon(
                          Icons.sunny,
                          size: 45,
                          color: Colors.black45,
                        ),
                      );
                    } else {
                      return ImageIcon(
                        size: 60,
                        NetworkImage(
                          'http://openweathermap.org/img/wn/${snapshot.data!.commonList?[7]["weather"][0]["icon"]}@2x.png',
                        ),
                        color: Colors.black45,
                      );
                    }
                  } else if (snapshot.hasError) {
                    return Text(
                        '${snapshot.error}${snapshot.data?.commonList}');
                  }

                  return Container();
                },
              ),
              FutureBuilder<Weather5Days>(
                future: futureWeatherWeek,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var tom =
                        "${snapshot.data?.commonList?[7]["main"]["temp"]?.toInt()}\u2103";
                    return Text(
                      tom,
                      style: GoogleFonts.fredoka(
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
            ],
          ),
          Column(
            children: [
              FutureBuilder<Weather5Days>(
                future: futureWeatherWeek,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var tom =
                        "${snapshot.data?.commonList?[8]["dt_txt"].toString().substring(11, 16)}";
                    return Text(
                      tom,
                      style: GoogleFonts.roboto(
                        fontSize: 12,
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
              FutureBuilder<Weather5Days>(
                future: futureWeatherWeek,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.commonList?[8]["weather"][0]["icon"] ==
                        "01d") {
                      return const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Icon(
                            Icons.sunny,
                            size: 45,
                            color: Colors.black45,
                          ),
                        ),
                      );
                    } else {
                      return ImageIcon(
                        size: 60,
                        NetworkImage(
                          'http://openweathermap.org/img/wn/${snapshot.data!.commonList?[8]["weather"][0]["icon"]}@2x.png',
                        ),
                        color: Colors.black45,
                      );
                    }
                  } else if (snapshot.hasError) {
                    return Text(
                        '${snapshot.error}${snapshot.data?.commonList}');
                  }

                  return Container();
                },
              ),
              FutureBuilder<Weather5Days>(
                future: futureWeatherWeek,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var tom =
                        "${snapshot.data?.commonList?[8]["main"]["temp"]?.toInt()}\u2103";
                    return Text(
                      tom,
                      style: GoogleFonts.fredoka(
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
            ],
          ),
        ],
      ),
    );
  }


//   Future<void> _handlePressButton() async {
//     Prediction? p = await PlacesAutocomplete.show(
//       context: context,
//       apiKey: kGoogleApiKey,
//       language: "en",
//       decoration: InputDecoration(
//         hintText: 'Search',
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(20),
//           borderSide: BorderSide(
//             color: Colors.white,
//           ),
//         ),
//       ),
//       components: [Component(Component.country, "en")],
//     );
//
//     displayPrediction(p!, homeScaffoldKey.currentState);
//   }
//
//
// Future<Null> displayPrediction(Prediction p, ScaffoldState? scaffold) async {
//   if (p != null) {
//     // get detail (lat/lng)
//     GoogleMapsPlaces _places = GoogleMapsPlaces(
//       apiKey: kGoogleApiKey,
//       apiHeaders: await GoogleApiHeaders().getHeaders(),
//     );
//     PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId.toString());
//     final lat = detail.result.geometry?.location.lat;
//     final lng = detail.result.geometry?.location.lng;
//
//     // scaffold?.showSnackBar(
//     //   SnackBar(content: Text("${p.description} - $lat/$lng")),
//     // );
//   }
// }
}
