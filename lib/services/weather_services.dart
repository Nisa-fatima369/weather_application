import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_application/models/city_search_model.dart';
import 'package:weather_application/models/weekly_weather_api_model.dart';

const String apiKey = '9793a0418d7b091b0aa401a45f81c20e';

class WeatherRepository {

  Future<WeeklyFiveDayWeatherModel> fetchWeeklyWeatherDataApi() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
    );

    final double latitude = position.latitude;
    final double longitude = position.longitude;

    String url =
        'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&units=metric&appid=9793a0418d7b091b0aa401a45f81c20e';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return WeeklyFiveDayWeatherModel.fromJson(data);
    }
    throw Exception('Failed to load data');
  }
}

class WeatherService {
  final String apiKey = '9793a0418d7b091b0aa401a45f81c20e';
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  WeatherService();

  Future<CitySearchModel> getWeatherByCity(String cityName) async {
    final String url = '$baseUrl?q=$cityName&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return CitySearchModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  // Future<List<CitySearchModel>> searchCities(String query) async {
  //   final String url = '$baseUrl?q=$query&appid=$apiKey&units=metric';

  //   try {
  //     final response = await http.get(Uri.parse(url));

  //     if (response.statusCode == 200) {
  //       final jsonData = json.decode(response.body);

  //       // Check if the response contains a list of cities
  //       if (jsonData['list'] != null && jsonData['list'] is List) {
  //         List<dynamic> citiesData = jsonData['list'];
  //         List<CitySearchModel> results =
  //             citiesData.map((e) => CitySearchModel.fromJson(e)).toList();
  //         return results;
  //       } else {
  //         throw Exception('No cities found for the given query');
  //       }
  //     } else {
  //       throw Exception('Failed to load city search results');
  //     }
  //   } catch (error) {
  //     throw Exception('Error: $error');
  //   }
  // }
}
