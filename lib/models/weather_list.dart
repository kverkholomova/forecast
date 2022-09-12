class Autogenerated {
  List<WeatherDescription>? weatherDescription;

  Autogenerated({required this.weatherDescription});

  Autogenerated.fromJson(Map<String, dynamic> json) {
    if (json['weather'] != null) {
      weatherDescription = <WeatherDescription>[];
      json['weather_description'].forEach((v) {
        weatherDescription?.add(new WeatherDescription.fromJson(v));
      });
    }
  }

}

class WeatherDescription {
  String? description;

  WeatherDescription({required this.description});

  WeatherDescription.fromJson(Map<String, dynamic> json) {
    description = json['description'];
  }

}

