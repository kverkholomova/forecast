import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:forecast/screens/main_page.dart';
import 'package:forecast/screens/today_forecast.dart';
import 'package:forecast/widgets/loader.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:forecast/models/weather_week_model.dart';
import 'package:forecast/screens/another_day_forecast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';

import '../api/weather_week_api.dart';
import '../app.dart';
import '../utils/location_functionality.dart';
import '../widgets/cache_manager.dart';
import '../widgets/icons.dart';
import 'package:http/http.dart' as http;

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
bool today = true;

class _HomePageState extends State<HomePage> {
  late Future<Weather5Days> futureWeatherWeek;
  Random random = Random();
  var uuid= const Uuid();
  Uuid _sessionToken = const Uuid();
  List<dynamic>_placeList = [];

  weekDaysName(int dayCount) {
    DateTime dateWeek = DateTime.now().add(Duration(days: dayCount));
    return dateWeek;
  }

  void changeIndex() {
    setState(() => index = random.nextInt(5));
  }

  late VideoPlayerController _controller;

  checkCityName() async {
    final responseName = await http.get(Uri.parse(
        'http://api.openweathermap.org/data/2.5/forecast?q=$city&cnt=40&appid=43ec70748cae1130be4146090de59761&units=metric'));

    if (responseName.statusCode != 200) {

      rightCity = false;
    }
  }

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
  bool isPlaying = false;
  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loader()
        : SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height <= 684
                            ? MediaQuery.of(context).size.height * 0.27
                            : MediaQuery.of(context).size.height * 0.27,
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 1,
                            height: MediaQuery.of(context).size.height <= 684
                                ? MediaQuery.of(context).size.height * 0.57
                                : MediaQuery.of(context).size.height * 0.5,
                            child: FutureBuilder<Weather5Days>(
                              future: HttpProvider().getData(url),
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
                                    fontSize: 26,
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
                    ),
                    Padding(padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.width * 0.03),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: FloatingActionButton(
                          backgroundColor: Colors.white,
                          elevation: 0,
                          child:isPlaying==false?Icon(Icons.refresh, size: 40, color: Colors.indigoAccent.withOpacity(0.7),)
                              :CircularProgressIndicator(strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.indigoAccent.withOpacity(0.7)),),
                          onPressed: ()async {
                            setState(() {
                              isPlaying = true;
                            });Future.delayed(
                                Duration(milliseconds: 2000),(){
                              setState(() {
                                isPlaying = false;
                                DefaultCacheManager().emptyCache();
                                const MyApp();
                                HttpProvider().getData(url);
                              });
                            }
                            );


                          },),
                        ),
                        ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.width * 0.02),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.75,
                          // height: MediaQuery.of(context).size.width * 0.13,
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextField(
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
                                  return Container(
                                    color: Colors.white,
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.only(top: 8, left: 5),
                                      minLeadingWidth: 10,
                                      horizontalTitleGap: 5,
                                      title: GestureDetector(
                                        onTap: ()async {

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
                                            const Padding(
                                              padding: EdgeInsets.only(right: 7),
                                              child: Icon(Icons.location_on_outlined),
                                            ),
                                            Expanded(child: Text(_placeList[index]["description"])),
                                          ],
                                        ),
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
          future: HttpProvider().getData(url),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var tom =
                  "${snapshot.data?.commonList?[0]["dt_txt"].toString().substring(0, 4)}.${snapshot.data?.commonList?[0]["dt_txt"].toString().substring(5, 7)}.${snapshot.data?.commonList?[0]["dt_txt"].toString().substring(8, 10)}";
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
          future: HttpProvider().getData(url),
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
          future: HttpProvider().getData(url),
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
          future: HttpProvider().getData(url),
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
          future: HttpProvider().getData(url),
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
          future: HttpProvider().getData(url),
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
                                    : snapshot.data!.commonList![0]["weather"]
                                                [0]["description"] ==
                                            "overcast clouds"
                                        ? getController(
                                            "assets/windy_cloud.mp4")
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
                  selectedIndex = 1;
                  controllerTab.index = 1;
                  loadingToday = true;
                  loadingNew = true;

                  dateWeekName = DateFormat('EEEE').format(weekDaysName(1));
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
                    future: HttpProvider().getData(url),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        description = snapshot.data!.commonList![8]["weather"]
                            [0]["description"];

                        var tom =
                            "${snapshot.data?.commonList?[8]["dt_txt"].toString().substring(5, 7)}.${snapshot.data?.commonList?[8]["dt_txt"].toString().substring(8, 11)}";
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
                    future: HttpProvider().getData(url),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.commonList?[8]["weather"][0]
                                    ["icon"] ==
                                "01n" ||
                            snapshot.data!.commonList?[8]["weather"][0]
                                    ["icon"] ==
                                "01d") {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
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
                  Text(
                    DateFormat('EEEE').format(weekDaysName(1)),
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: Colors.black45,
                    ),
                  ),
                  FutureBuilder<Weather5Days>(
                    future: HttpProvider().getData(url),
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  today = false;
                  selectedIndex = 1;
                  controllerTab.index = 1;
                  loadingNew = true;
                  loadingToday = true;
                  dateWeekName = DateFormat('EEEE').format(weekDaysName(2));
                  numDay = 16;
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
                    future: HttpProvider().getData(url),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        description = snapshot.data!.commonList![16]["weather"]
                            [0]["description"];
                        var tom =
                            "${snapshot.data?.commonList?[16]["dt_txt"].toString().substring(5, 7)}.${snapshot.data?.commonList?[16]["dt_txt"].toString().substring(8, 11)}";
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
                    future: HttpProvider().getData(url),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.commonList?[16]["weather"][0]
                                    ["icon"] ==
                                "01n" ||
                            snapshot.data!.commonList?[16]["weather"][0]
                                    ["icon"] ==
                                "01d") {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
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
                              'http://openweathermap.org/img/wn/${snapshot.data!.commonList?[16]["weather"][0]["icon"]}@2x.png',
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
                  Text(
                    DateFormat('EEEE').format(weekDaysName(2)),
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: Colors.black45,
                    ),
                  ),
                  FutureBuilder<Weather5Days>(
                    future: HttpProvider().getData(url),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var tom =
                            "${snapshot.data?.commonList?[16]["main"]["temp"]?.toInt()}\u2103";
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  today = false;
                  selectedIndex = 1;
                  controllerTab.index = 1;
                  loadingNew = true;
                  loadingToday = true;

                  dateWeekName = DateFormat('EEEE').format(weekDaysName(3));
                  numDay = 24;
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
                    future: HttpProvider().getData(url),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        description = snapshot.data!.commonList![24]["weather"]
                            [0]["description"];
                        var tom =
                            "${snapshot.data?.commonList?[24]["dt_txt"].toString().substring(5, 7)}.${snapshot.data?.commonList?[24]["dt_txt"].toString().substring(8, 11)}";
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
                    future: HttpProvider().getData(url),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.commonList?[24]["weather"][0]
                                    ["icon"] ==
                                "01n" ||
                            snapshot.data!.commonList?[24]["weather"][0]
                                    ["icon"] ==
                                "01d") {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
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
                              'http://openweathermap.org/img/wn/${snapshot.data!.commonList?[24]["weather"][0]["icon"]}@2x.png',
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
                  Text(
                    DateFormat('EEEE').format(weekDaysName(3)),
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: Colors.black45,
                    ),
                  ),
                  FutureBuilder<Weather5Days>(
                    future: HttpProvider().getData(url),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var tom =
                            "${snapshot.data?.commonList?[24]["main"]["temp"]?.toInt()}\u2103";
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  today = false;
                  selectedIndex = 1;
                  controllerTab.index = 1;
                  loadingNew = true;
                  loadingToday = true;
                  dateWeekName = DateFormat('EEEE').format(weekDaysName(4));
                  numDay = 32;
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
                    future: HttpProvider().getData(url),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        description = snapshot.data!.commonList![32]["weather"]
                            [0]["description"];
                        var tom =
                            "${snapshot.data?.commonList?[32]["dt_txt"].toString().substring(5, 7)}.${snapshot.data?.commonList?[32]["dt_txt"].toString().substring(8, 11)}";
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
                    future: HttpProvider().getData(url),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.commonList?[32]["weather"][0]
                                    ["icon"] ==
                                "01n" ||
                            snapshot.data!.commonList?[32]["weather"][0]
                                    ["icon"] ==
                                "01d") {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
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
                              'http://openweathermap.org/img/wn/${snapshot.data!.commonList?[32]["weather"][0]["icon"]}@2x.png',
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
                  Text(
                    DateFormat('EEEE').format(weekDaysName(4)),
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: Colors.black45,
                    ),
                  ),
                  FutureBuilder<Weather5Days>(
                    future: HttpProvider().getData(url),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var tom =
                            "${snapshot.data?.commonList?[32]["main"]["temp"]?.toInt()}\u2103";
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  today = false;
                  selectedIndex = 1;
                  controllerTab.index = 1;
                  loadingNew = true;
                  dateWeekName = DateFormat('EEEE').format(weekDaysName(5));
                  numDay = 39;
                  changeIndex();
                  loadingToday = true;
                });

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MainPage()),
                );
              },
              child: Column(
                children: [
                  FutureBuilder<Weather5Days>(
                    future: HttpProvider().getData(url),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        description = snapshot.data!.commonList![39]["weather"]
                            [0]["description"];
                        var tom =
                            "${snapshot.data?.commonList?[39]["dt_txt"].toString().substring(5, 7)}.${snapshot.data?.commonList?[39]["dt_txt"].toString().substring(8, 11)}";
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
                    future: HttpProvider().getData(url),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.commonList?[39]["weather"][0]
                                    ["icon"] ==
                                "01n" ||
                            snapshot.data!.commonList?[39]["weather"][0]
                                    ["icon"] ==
                                "01d") {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
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
                              'http://openweathermap.org/img/wn/${snapshot.data!.commonList?[39]["weather"][0]["icon"]}@2x.png',
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
                  Text(
                    DateFormat('EEEE').format(weekDaysName(5)),
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: Colors.black45,
                    ),
                  ),
                  FutureBuilder<Weather5Days>(
                    future: HttpProvider().getData(url),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var tom =
                            "${snapshot.data?.commonList?[39]["main"]["temp"]?.toInt()}\u2103";
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
            ),
          ),
        ],
      ),
    );
  }
}
