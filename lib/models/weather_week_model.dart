
// class List {
//   int? dt;
//   Main? main;
//   String? dtTxt;
//
//
//   List(
//       {required this.dt,
//         required this.main,
//         required this.dtTxt,
//       });
//
//   factory List.fromJson(Map<String, dynamic> json) {
//     return List(
//         dt: json['dt'],
//     main: json['main'] != null ? new Main.fromJson(json['main']) : null,
//     dtTxt:json['dt_txt']
//     );
//   }
// }
//
// class Main {
//   double? temp;
//
//   Main(
//       {required this.temp,
//       });
//
//   Main.fromJson(Map<String, dynamic> json) {
//     temp = json['temp'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['temp'] = this.temp;
//     return data;
//   }
// }
//
// class WeatherWeek {
//   int? id;
//   String? main;
//   String? description;
//   String? icon;
//
//   WeatherWeek({required this.id, required this.main, required this.description, required this.icon});
//
//   WeatherWeek.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     main = json['main'];
//     description = json['description'];
//     icon = json['icon'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['main'] = this.main;
//     data['description'] = this.description;
//     data['icon'] = this.icon;
//     return data;
//   }
// }

class Weather5Days {
  // final String? today_description;
  // final double? today_temp;
  final String? tomorrow;

  Weather5Days({
    // required this.today_description,
    // required this.today_temp,
    required this.tomorrow,
  });

  factory Weather5Days.fromJson(Map<String, dynamic> json) {
    return Weather5Days(
      // today_description: json["list"][1]["weather"]["description"],
      // today_temp: json["list"][1]["main"]["temp"],
      tomorrow: json['list'][7]["dt_txt"]
    );
  }
}


