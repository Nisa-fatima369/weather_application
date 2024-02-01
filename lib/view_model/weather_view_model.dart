
import 'package:weather_application/models/weekly_weather_api_model.dart';
import 'package:weather_application/services/weather_services.dart';

class WeatherViewModel{
  final service = WeatherRepository();

  Future<WeeklyFiveDayWeatherModel> fetchWeeklyWeatherDataApi() async{
    final response = await service.fetchWeeklyWeatherDataApi();
    return response; 
  }
}