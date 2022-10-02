import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:forecast/models/weather_week_model.dart';
import 'package:forecast/screens/home_page.dart';
import 'package:forecast/screens/today_forecast.dart';
import 'package:forecast/widgets/icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';

import '../api/weather_week_api.dart';
import '../constants.dart';
import '../utils/location_functionality.dart';
import '../widgets/loader.dart';
import 'main_page.dart';
import 'package:http/http.dart' as http;

class AnotherDayForecast extends StatefulWidget {
  const AnotherDayForecast({Key? key}) : super(key: key);

  @override
  State<AnotherDayForecast> createState() => _AnotherDayForecastState();
}

bool loadingNew = true;

class _AnotherDayForecastState extends State<AnotherDayForecast> {
  late Future<Weather5Days> futureWeatherWeek;

  var uuid= const Uuid();
  Uuid _sessionToken = const Uuid();
  List<dynamic>_placeList = [];
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
      loadingNew = false;
    });
  }
  late TextEditingController textEditingController;

  checkCityName()async{
    final responseName = await http.get(Uri.parse('http://api.openweathermap.org/data/2.5/forecast?q=$city&cnt=40&appid=43ec70748cae1130be4146090de59761&units=metric'));

    if (responseName.statusCode != 200){
      print("TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT");
      rightCity = false;
    }
  }
  @override
  void initState() {
    super.initState();
    futureWeatherWeek = fetchWeatherForWeek();
    getController("assets/clouds.mp4");
    textEditingController = TextEditingController();

    textEditingController.addListener(() {
      _onChanged();
    });

    Timer(const Duration(seconds: 3), () => dataLoadFunction());
    setState(() {
      description = '';
      serviceEn();
      permissGranted();
    });
  }

  Random random = Random();

  void changeIndex() {
    setState(() => index = random.nextInt(5));
  }

  void _onChanged() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4() as Uuid;
      });
    }
    getSuggestion(textEditingController.text);
  }


  weekDaysName(int dayCount) {
    DateTime dateWeek = DateTime.now().add(Duration(days: dayCount));
    return dateWeek;
  }

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
  void dispose() {
    super.dispose();
    _controller.dispose();
    textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loadingNew
        ? const Loader()
        : SafeArea(
          child: Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Stack(
            children:[
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery
                      .of(context)
                      .size
                      .height<=684? MediaQuery
                      .of(context)
                      .size
                      .height* 0.27:MediaQuery
                      .of(context)
                      .size
                      .height* 0.27,
                ),
                child: Align(
                    alignment: Alignment.center,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width *1 ,
                        height: MediaQuery
                            .of(context)
                            .size
                            .height *0.5,
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
            ),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery
                          .of(context)
                          .size
                          .height * 0.035),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: buildTemperature(),
                  ),
                ),
                Positioned(
                  top: MediaQuery
                      .of(context)
                      .size
                      .height * 0.15,
                  // left: MediaQuery.of(context).size.height * 0.021,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: buildDescription(),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const HumidityIcon(),
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.045,
                              right: MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.045
                          ),
                          child: buildHumidity(),
                        ),

                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const WindSpeedIcon(),
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.01,
                              // right: MediaQuery
                              //     .of(context)
                              //     .size
                              //     .height * 0.057
                          ),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: buildWindSpeed(),
                          ),
                        ),
                        const WindKmH(),

                      ],
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
                    child: buildCityName(),
                  ),
                ),
                Column(
                  children: [
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
                            dateWeekName,
                            style: GoogleFonts.roboto(
                              fontSize: 24,
                              color: colors[index],
                            ),
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery
                            .of(context)
                            .size
                            .height * 0,
                      ),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: buildDate(),
                      ),
                    ),
                  ],
                ),
              ],
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
                        setState(() async {
                          loadingNew=true;
                          city = value;
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
                        });
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
                        .height * 0.7),
                child: buildBottomWeather(context),
              ),
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.width*0.02),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    // width: MediaQuery.of(context).size.width*0.9,
                    // height: MediaQuery.of(context).size.width*0.13,
                    color: Colors.white,
                    child: Column(
                      children: [
                        TextField(
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
                          // onSubmitted: (String value) async {
                          //   setState(() async {
                          //     loadingNew=true;
                          //     city = value;
                          //     await checkCityName();
                          //     if (rightCity==true){
                          //       Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (context) => const MainPage()),
                          //       );
                          //     }
                          //     else{
                          //       city = "";
                          //       Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (context) => const MainPage()),
                          //       );
                          //     }
                          //   });
                          //   city = value;
                          //   Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //         const MainPage()),
                          //   );
                          // },
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _placeList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              color: Colors.white,
                              child: ListTile(
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
                                  child: Card(
                                      color: Colors.white,
                                      child: Text(_placeList[index]["description"])),
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
            ]),
      )
    ),
        );
  }

  FutureBuilder<Weather5Days> buildDate() {
    return FutureBuilder<Weather5Days>(
                  future: futureWeatherWeek,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var tom =
                          "${snapshot.data?.commonList?[numDay]["dt_txt"]
                          .toString()
                          .substring(0, 4)}.${snapshot.data
                          ?.commonList?[numDay]["dt_txt"]
                          .toString()
                          .substring(5, 7)}.${snapshot.data
                          ?.commonList?[numDay]["dt_txt"]
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
                );
  }

  FutureBuilder<Weather5Days> buildCityName() {
    return FutureBuilder<Weather5Days>(
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
                  );
  }

  FutureBuilder<Weather5Days> buildWindSpeed() {
    return FutureBuilder<Weather5Days>(
                  future: futureWeatherWeek,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var tom =
                          "${snapshot.data
                          ?.commonList?[numDay]["wind"]["speed"]}";
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
                );
  }

  FutureBuilder<Weather5Days> buildHumidity() {
    return FutureBuilder<Weather5Days>(
                  future: futureWeatherWeek,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var tom =
                          "${snapshot.data
                          ?.commonList?[numDay]["main"]["humidity"]} %";
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
                );
  }

  FutureBuilder<Weather5Days> buildDescription() {
    return FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var tom =
                            "${snapshot.data!
                            .commonList?[numDay]["weather"][0]["description"]}";
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
                  );
  }

  FutureBuilder<Weather5Days> buildTemperature() {
    return FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var tom =
                            "${snapshot.data
                            ?.commonList?[numDay]["main"]["temp"]
                            ?.toInt()}\u2103";
                        return Text(
                          tom,
                          style: GoogleFonts.openSans(
                            fontSize: 64,
                            color: colors[index],
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                            '${snapshot.error}${snapshot.data?.commonList}');
                      }
                      return Container();
                    },
                  );
  }

  VideoPlayerController controllerVideo(AsyncSnapshot<Weather5Days> snapshot) {
    return snapshot.data!.commonList![numDay]
    ["weather"][0]["description"] ==
        "clear sky"
        ? getController("assets/sunny_day.mp4")
        : snapshot.data!.commonList![numDay]["weather"]
    [0]["description"] ==
        "few clouds"
        ? getController("assets/sunny.mp4")
        : snapshot.data!.commonList![numDay]
    ["weather"][0]
    ["description"] ==
        "scattered clouds"
        ? getController(
        "assets/windy_cloud.mp4")
        : snapshot.data!.commonList![numDay]
    ["weather"][0]
    ["description"] ==
        "broken clouds"
        ? getController("assets/windy_cloud.mp4")
        : snapshot.data!.commonList![numDay]["weather"][0]["description"] ==
        "shower rain"
        ? getController("assets/rainy_day.mp4")
        : snapshot.data!.commonList![numDay]["weather"][0]["description"] ==
        "light rain"
        ? getController("assets/cloudy_rain.mp4")
        : snapshot.data!.commonList![numDay]["weather"][0]["description"] ==
        "thunderstorm"
        ? getController("assets/thunder_rain.mp4")
        : snapshot.data!.commonList![numDay]["weather"][0]["description"] ==
        "snow"
        ? getController("assets/snowfall.mp4")
        : snapshot.data!.commonList![numDay]["weather"][0]["description"]
        .contains("rain")
        ? getController("assets/rainy_day.mp4")
        : snapshot.data!.commonList![numDay]["weather"][0]["description"]
        .contains("sun")
        ? getController("assets/sunny.mp4")
        : snapshot.data!.commonList![numDay]["weather"][0]["description"] ==
        "overcast clouds"
        ? getController("assets/windy_cloud.mp4")
        : getController("assets/warm_wind.mp4");
  }

  SingleChildScrollView buildBottomWeather(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  hourly=false;
                  today = true;
                  selectedIndex=1;
                  controllerTab.index = 1;
                  loadingToday = true;
                  loading = true;
                  numDay = 8;
                  changeIndex();
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MainPage()),
                );
              },
              child: Column(
                children: [
                  FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        description = snapshot.data!.commonList![0]["weather"][0]
                        ["description"];
                        iconNum =
                        snapshot.data!.commonList?[0]["weather"][0]["icon"];
                        var tom =
                            "${snapshot.data?.commonList?[0]["dt_txt"]
                            .toString()
                            .substring(5, 7)}.${snapshot.data
                            ?.commonList?[0]["dt_txt"].toString().substring(
                            8, 11)}";
                        return Text(
                          tom,
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            color: numDay == 0
                                ? Colors.indigoAccent.withOpacity(0.7)
                                : Colors.black45,
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
                        if (snapshot.data!.commonList?[0]["weather"][0]["icon"] ==
                            "01n"||snapshot.data!.commonList?[0]["weather"][0]["icon"] ==
                            "01d") {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Icon(
                              Icons.sunny,
                              size: 45,
                              color: numDay == 0 ? colors[index] : Colors.black45,
                            ),
                          );
                        } else {
                          return ImageIcon(
                            size: 60,
                            NetworkImage(
                              'http://openweathermap.org/img/wn/${snapshot.data!
                                  .commonList?[0]["weather"][0]["icon"]}@2x.png',
                            ),
                            color: numDay == 0 ? colors[index] : Colors.black45,
                          );
                        }
                      } else if (snapshot.hasError) {
                        return Text(
                            '${snapshot.error}${snapshot.data?.commonList}');
                      }

                      return Container();
                    },
                  ),
                  Text(
                    DateFormat('EEEE').format(weekDaysName(0)),
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: numDay == 0
                          ? Colors.indigoAccent.withOpacity(0.7)
                          : Colors.black45,
                    ),
                  ),
                  FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var tom =
                            "${snapshot.data?.commonList?[0]["main"]["temp"]
                            ?.toInt()}\u2103";
                        return Text(
                          tom,
                          style: GoogleFonts.fredoka(
                            fontSize: 18,
                            color: numDay == 0
                                ? Colors.indigoAccent.withOpacity(0.7)
                                : Colors.black45,
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
                  loadingNew = true;
                  numDay = 8;
                  changeIndex();
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MainPage()),
                );
              },
              child: Column(
                children: [
                  FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        description = snapshot.data!.commonList![8]["weather"][0]
                        ["description"];
                        var tom =
                            "${snapshot.data?.commonList?[8]["dt_txt"]
                            .toString()
                            .substring(5, 7)}.${snapshot.data
                            ?.commonList?[8]["dt_txt"].toString().substring(
                            8, 11)}";
                        return Text(
                          tom,
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            color: numDay == 8 ? colors[index] : Colors.black45,
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
                            "01n"||snapshot.data!.commonList?[8]["weather"][0]["icon"] ==
                            "01d") {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Icon(
                              Icons.sunny,
                              size: 45,
                              color: numDay == 8 ? colors[index] : Colors.black45,
                            ),
                          );
                        } else {
                          return ImageIcon(
                            size: 60,
                            NetworkImage(
                              'http://openweathermap.org/img/wn/${snapshot.data!
                                  .commonList?[8]["weather"][0]["icon"]}@2x.png',
                            ),
                            color: numDay == 8 ? colors[index] : Colors.black45,
                          );
                        }
                      } else if (snapshot.hasError) {
                        return Text(
                            '${snapshot.error}${snapshot.data?.commonList}');
                      }

                      return Container();
                    },
                  ),
                  Text(
                    DateFormat('EEEE').format(weekDaysName(1)),
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: numDay == 8 ? colors[index] : Colors.black45,
                    ),
                  ),
                  FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var tom =
                            "${snapshot.data?.commonList?[8]["main"]["temp"]
                            ?.toInt()}\u2103";
                        return Text(
                          tom,
                          style: GoogleFonts.fredoka(
                            fontSize: 18,
                            color: numDay == 8 ? colors[index] : Colors.black45,
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
                  loadingNew = true;
                  numDay = 16;
                  changeIndex();
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MainPage()),
                );
              },
              child: Column(
                children: [
                  FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        description = snapshot.data!.commonList![16]["weather"][0]
                        ["description"];
                        var tom =
                            "${snapshot.data?.commonList?[16]["dt_txt"]
                            .toString()
                            .substring(5, 7)}.${snapshot.data
                            ?.commonList?[16]["dt_txt"].toString().substring(
                            8, 11)}";
                        return Text(
                          tom,
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            color: numDay == 16 ? colors[index] : Colors.black45,
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
                        if (snapshot.data!
                            .commonList?[16]["weather"][0]["icon"] ==
                            "01n"||snapshot.data!
                            .commonList?[16]["weather"][0]["icon"] ==
                            "01d") {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Icon(
                              Icons.sunny,
                              size: 45,
                              color: numDay == 16 ? colors[index] : Colors
                                  .black45,
                            ),
                          );
                        } else {
                          return ImageIcon(
                            size: 60,
                            NetworkImage(
                              'http://openweathermap.org/img/wn/${snapshot.data!
                                  .commonList?[16]["weather"][0]["icon"]}@2x.png',
                            ),
                            color: numDay == 16 ? colors[index] : Colors.black45,
                          );
                        }
                      } else if (snapshot.hasError) {
                        return Text(
                            '${snapshot.error}${snapshot.data?.commonList}');
                      }

                      return Container();
                    },
                  ),
                  Text(
                    DateFormat('EEEE').format(weekDaysName(2)),
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: numDay == 16 ? colors[index] : Colors.black45,
                    ),
                  ),
                  FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var tom =
                            "${snapshot.data?.commonList?[16]["main"]["temp"]
                            ?.toInt()}\u2103";
                        return Text(
                          tom,
                          style: GoogleFonts.fredoka(
                            fontSize: 18,
                            color: numDay == 16 ? colors[index] : Colors.black45,
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
                  loadingNew = true;
                  numDay = 24;
                  changeIndex();
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AnotherDayForecast()),
                );
              },
              child: Column(
                children: [
                  FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        description = snapshot.data!.commonList![24]["weather"][0]
                        ["description"];
                        var tom =
                            "${snapshot.data?.commonList?[24]["dt_txt"]
                            .toString()
                            .substring(5, 7)}.${snapshot.data
                            ?.commonList?[24]["dt_txt"].toString().substring(
                            8, 11)}";
                        return Text(
                          tom,
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            color: numDay == 24 ? colors[index] : Colors.black45,
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
                        if (snapshot.data!
                            .commonList?[24]["weather"][0]["icon"] == "01n"||snapshot.data!
                            .commonList?[24]["weather"][0]["icon"] == "01d") {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Icon(
                              Icons.sunny,
                              size: 45,
                              color: numDay == 24
                                  ? colors[index]
                                  : Colors.black45,
                            ),
                          );
                        }
                        else {
                          return ImageIcon(
                            size: 60,
                            NetworkImage(
                              'http://openweathermap.org/img/wn/${snapshot.data!
                                  .commonList?[24]["weather"][0]["icon"]}@2x.png',
                            ),
                            color: numDay == 24 ? colors[index] : Colors.black45,
                          );
                        }
                      } else if (snapshot.hasError) {
                        return Text(
                            '${snapshot.error}${snapshot.data?.commonList}');
                      }

                      return Container();
                    },
                  ),
                  Text(
                    DateFormat('EEEE').format(weekDaysName(3)),
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: numDay == 24 ? colors[index] : Colors.black45,
                    ),
                  ),
                  FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var tom =
                            "${snapshot.data?.commonList?[24]["main"]["temp"]
                            ?.toInt()}\u2103";
                        return Text(
                          tom,
                          style: GoogleFonts.fredoka(
                            fontSize: 18,
                            color: numDay == 24 ? colors[index] : Colors.black45,
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
                  loadingNew = true;
                  numDay = 32;
                  changeIndex();
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AnotherDayForecast()),
                );
              },
              child: Column(
                children: [
                  FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        description = snapshot.data!.commonList![32]["weather"][0]
                        ["description"];
                        var tom =
                            "${snapshot.data?.commonList?[32]["dt_txt"]
                            .toString()
                            .substring(5, 7)}.${snapshot.data
                            ?.commonList?[32]["dt_txt"].toString().substring(
                            8, 11)}";
                        return Text(
                          tom,
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            color: numDay == 32 ? colors[index] : Colors.black45,
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
                        if (snapshot.data!
                            .commonList?[32]["weather"][0]["icon"] == "01n"||snapshot.data!
                            .commonList?[32]["weather"][0]["icon"] == "01d") {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Icon(
                              Icons.sunny,
                              size: 45,
                              color: numDay == 32
                                  ? colors[index]
                                  : Colors.black45,
                            ),
                          );
                        }
                        else {
                          return ImageIcon(
                            size: 60,
                            NetworkImage(
                              'http://openweathermap.org/img/wn/${snapshot.data!
                                  .commonList?[32]["weather"][0]["icon"]}@2x.png',
                            ),
                            color: numDay == 32 ? colors[index] : Colors.black45,
                          );
                        }
                      } else if (snapshot.hasError) {
                        return Text(
                            '${snapshot.error}${snapshot.data?.commonList}');
                      }

                      return Container();
                    },
                  ),
                  Text(
                    DateFormat('EEEE').format(weekDaysName(4)),
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: numDay == 32 ? colors[index] : Colors.black45,
                    ),
                  ),
                  FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var tom =
                            "${snapshot.data?.commonList?[32]["main"]["temp"]
                            ?.toInt()}\u2103";
                        return Text(
                          tom,
                          style: GoogleFonts.fredoka(
                            fontSize: 18,
                            color: numDay == 32 ? colors[index] : Colors.black45,
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  today = false;
                  selectedIndex=1;
                  controllerTab.index = 1;
                  loadingNew = true;
                  numDay = 39;
                  changeIndex();
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AnotherDayForecast()),
                );
              },
              child: Column(
                children: [
                  FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        description = snapshot.data!.commonList![39]["weather"][0]
                        ["description"];
                        var tom =
                            "${snapshot.data?.commonList?[39]["dt_txt"]
                            .toString()
                            .substring(5, 7)}.${snapshot.data
                            ?.commonList?[39]["dt_txt"].toString().substring(
                            8, 11)}";
                        return Text(
                          tom,
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            color: numDay == 39 ? colors[index] : Colors.black45,
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
                        if (snapshot.data!
                            .commonList?[39]["weather"][0]["icon"] == "01n"||snapshot.data!
                            .commonList?[39]["weather"][0]["icon"] == "01d") {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Icon(
                              Icons.sunny,
                              size: 45,
                              color: numDay == 39
                                  ? colors[index]
                                  : Colors.black45,
                            ),
                          );
                        }
                        else {
                          return ImageIcon(
                            size: 60,
                            NetworkImage(
                              'http://openweathermap.org/img/wn/${snapshot.data!
                                  .commonList?[39]["weather"][0]["icon"]}@2x.png',
                            ),
                            color: numDay == 39 ? colors[index] : Colors.black45,
                          );
                        }
                      } else if (snapshot.hasError) {
                        return Text(
                            '${snapshot.error}${snapshot.data?.commonList}');
                      }

                      return Container();
                    },
                  ),
                  Text(
                    DateFormat('EEEE').format(weekDaysName(5)),
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: numDay == 39 ? colors[index] : Colors.black45,
                    ),
                  ),
                  FutureBuilder<Weather5Days>(
                    future: futureWeatherWeek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var tom =
                            "${snapshot.data?.commonList?[39]["main"]["temp"]
                            ?.toInt()}\u2103";
                        return Text(
                          tom,
                          style: GoogleFonts.fredoka(
                            fontSize: 18,
                            color: numDay == 39 ? colors[index] : Colors.black45,
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
            ),
          ),
        ],
      ),
    );
  }
}
