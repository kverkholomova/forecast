
import 'package:test/test.dart';
import 'package:http/http.dart' as http;

void main(){
  late Uri? url;
  setUp(() async {
    url = Uri.parse('http://api.openweathermap.org/data/2.5/forecast?q=Slupsk&cnt=40&appid=43ec70748cae1130be4146090de59761&units=metric');
  });

  tearDown(() async {
    url = null;
  });
  group('fetchWeather', () {
    test('returns weather if the http call completes successfully', () async {
      var apiResult = await http.get(url!);
      expect(apiResult.statusCode, 200);

    });
    test('returns weather data if the http call completes successfully and is not null', () async {
      var apiResult = await http.get(url!);
      expect(apiResult.body.toString().trim(), isNot(''));

    });
  });
}
