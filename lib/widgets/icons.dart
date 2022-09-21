import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

class HumidityIcon extends StatelessWidget {
  const HumidityIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery
              .of(context)
              .size
              .height * 0.04,
          right: MediaQuery
              .of(context)
              .size
              .height * 0.125),
      child: const Align(
        alignment: Alignment.topRight,
        child: Icon(
          WeatherIcons.humidity,
          color: Colors.black45,
          size: 20,
        ),
      ),
    );
  }
}

class WindSpeedIcon extends StatelessWidget {
  const WindSpeedIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery
              .of(context)
              .size
              .height * 0.002,
          right: MediaQuery
              .of(context)
              .size
              .height * 0.13),
      child: const Align(
        alignment: Alignment.topRight,
        child: Icon(
          WeatherIcons.cloudy_windy,
          color: Colors.black45,
          size: 18,
        ),
      ),
    );
  }
}