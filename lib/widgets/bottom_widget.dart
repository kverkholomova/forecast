import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forecast/models/weather_week_model.dart';
import 'package:google_fonts/google_fonts.dart';

import '../api/weather_week_api.dart';

class BottomWidget extends StatelessWidget {
  const BottomWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  FutureBuilder<Weather5Days>(
                    future: fetchWeatherForWeek(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        // print("MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM");
                        // print(snapshot.data?.date);
                        var tom = snapshot.data?.city!.name;
                        return Text(
                          "${snapshot.data?.city!.name}",
                            style: GoogleFonts.roboto(
                                  fontSize: 12,
                                  color: Colors.black45,
                                ),
                        );
                      } else if (snapshot.hasError) {
                        print("ERRRRROOOOOOOOOOOOOOOOOORRRR");
                        return Text('${snapshot.error}${snapshot.data?.list}');
                      }
                      print("MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM");
                      print(snapshot.data!.city!.name);
                      return const CircularProgressIndicator();
                    },
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
                  Text(
                    "18\u2103",
                    style: GoogleFonts.fredoka(
                      fontSize: 18,
                      color: Colors.black45,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Text(
                    "09.09",
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: Colors.black45,
                    ),
                  ),
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
                  Text(
                    "18\u2103",
                    style: GoogleFonts.fredoka(
                      fontSize: 18,
                      color: Colors.black45,
                    ),
                  )
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}