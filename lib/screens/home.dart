import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather_application/models/weekly_weather_api_model.dart';
import 'package:weather_application/view_model/weather_view_model.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  WeatherViewModel weatherViewModel = WeatherViewModel();
  final format = DateFormat('MMMM dd, yyyy');
  final weeklyFormat = DateFormat('MMMM dd');
  String backgroundImageUrl = '';
  Future<List<WeatherList>>? hourlyWeatherData;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    _getCurrentLocation();
    fetchUserLocationAndBackgroundImage();
    hourlyWeatherData = fetchHourlyWeatherData();
  }

  Future<List<WeatherList>> fetchHourlyWeatherData() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
    );

    final double latitude = position.latitude;
    final double longitude = position.longitude;
    String apiKey = '9793a0418d7b091b0aa401a45f81c20e';
    String url =
        'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&units=metric&appid=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      List<WeatherList> hourlyWeatherList = [];
      DateTime currentDate = DateTime.now();
      for (var item in data['list']) {
        DateTime itemDate = DateTime.parse(item['dt_txt']);
        if (itemDate.day == currentDate.day) {
          hourlyWeatherList.add(WeatherList.fromJson(item));
        }
      }
      return hourlyWeatherList;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> fetchUserLocationAndBackgroundImage() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );

      const apiKey = 'uZboQutRGvDmF4Aco6DvN0PLaNAzjV3cgGYnPghKShM';
      final response = await http.get(
        Uri.parse(
          'https://api.unsplash.com/photos/random?query=city&client_id=$apiKey&orientation=landscape&lat=${position.latitude}&lon=${position.longitude}',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          backgroundImageUrl = data['urls']['regular'];
        });
      }
    } catch (error) {
      debugPrint('Error fetching user location and background image: $error');
    }
  }

  Future _requestLocationPermission() async {
    LocationPermission locationPermission;
    locationPermission = await Geolocator.requestPermission();
    var permission = await Permission.location.status;
    if (permission.isGranted) {
      _handleLocationAccess();
    } else if (permission.isDenied) {
      _requestLocationPermission();
    } else if (permission.isPermanentlyDenied) {
      _showSettingsDialog();
    }
  }

  void _handleLocationAccess() {
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    try {
      var position = await Geolocator.getCurrentPosition();

      double latitude = position.latitude;
      double longitude = position.longitude;
      debugPrint('Latitude: $latitude, Longitude: $longitude');
    } catch (e) {
      debugPrint("Error getting location: $e");
    }
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Location Permission"),
          content: const Text(
              "Location permission is required to access this feature. Please grant the permission in app settings."),
          actions: <Widget>[
            TextButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
                  Color(0XFFFEC260),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade700,
      body: Stack(
        children: [
          backgroundImageUrl.isNotEmpty
              ? Image.network(
                  backgroundImageUrl,
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                )
              : const SizedBox.shrink(),
          Positioned.fill(
            child: FutureBuilder<WeeklyFiveDayWeatherModel>(
              future: weatherViewModel.fetchWeeklyWeatherDataApi(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData) {
                  return const Center(
                    child: Text('No data available'),
                  );
                } else {
                  WeeklyFiveDayWeatherModel weatherData = snapshot.data!;
                  DateTime dateTime =
                      DateTime.parse(snapshot.data!.list![0].dtTxt.toString());

                  return SafeArea(
                    child: SizedBox(
                      height: size.height * 0.99,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  child: const Icon(Icons.menu),
                                  onTap: () {
                                    Navigator.pushNamed(context, '/third');
                                  },
                                ),
                                const Spacer(),
                                GestureDetector(
                                  child: const Icon(
                                    Icons.search,
                                    size: 36,
                                  ),
                                  onTap: () {
                                    Navigator.pushNamed(context, '/second');
                                  },
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  child: const Icon(
                                    Icons.bookmark_outline,
                                    size: 36,
                                  ),
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.location_on),
                              const SizedBox(width: 10),
                              Text(
                                '${snapshot.data!.city!.name}',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            weeklyFormat.format(dateTime),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontSize: 30),
                          ),
                          const SizedBox(height: 20),
                          Image.network(
                            'https://openweathermap.org/img/w/${snapshot.data!.list![0].weather![0].icon}.png',
                            width: 50,
                            height: 50,
                          ),
                          Text(
                            '${snapshot.data!.list![0].weather![0].main}',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          Text(
                            '${snapshot.data!.list![0].main!.temp!.toStringAsFixed(0)} °C',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          const SizedBox(height: 100),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: Colors.blueGrey.shade800
                                      .withOpacity(0.8)),
                              height: 100,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Icon(Icons.water_drop),
                                      Text(
                                        'HUMIDITY',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                      Text(
                                        '${snapshot.data!.list![0].main!.humidity} %',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Icon(Icons.air),
                                      Text(
                                        'WIND',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                      Text(
                                        '${snapshot.data!.list![0].wind!.speed} km/h',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Icon(Icons.thermostat),
                                      Text(
                                        'FEELS LIKE',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                      Text(
                                        '${snapshot.data!.list![0].main!.feelsLike!.toStringAsFixed(0)} °C',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            height: 160,
                            width: size.width * 0.99,
                            child: Center(
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: (weatherData.list!.length - 1) ~/ 8,
                                itemBuilder: (context, i) {
                                  int index = (i + 1) * 8;
                                  DateTime date = DateTime.parse(
                                      weatherData.list![index].dtTxt!);
                                  String formattedDate =
                                      DateFormat('E d').format(date);

                                  return Container(
                                    height: 160,
                                    width: 100,
                                    margin: const EdgeInsets.all(8),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey.shade800
                                          .withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          formattedDate,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                        Image.network(
                                          'https://openweathermap.org/img/w/${weatherData.list![i + 1].weather![0].icon}.png',
                                          width: 40,
                                          height: 40,
                                        ),
                                        Text(
                                          '${weatherData.list![i + 1].main!.temp!.toStringAsFixed(0)} °',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                        Text(
                                          '${snapshot.data!.list![0].wind!.speed} km/h',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          Positioned(
            bottom: 180,
            left: 15,
            child: Text(
              'Hourly Forecast',
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(fontSize: 26, fontWeight: FontWeight.w600),
            ),
          ),
          Positioned(
            bottom: 20,
            child: hourlyWeatherData != null
                ? FutureBuilder<List<WeatherList>>(
                    future: hourlyWeatherData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text('No hourly data available'),
                        );
                      } else {
                        return Center(
                          child: SizedBox(
                            height: 140,
                            width: size.width * 0.99,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, i) {
                                DateTime date =
                                    DateTime.parse(snapshot.data![i].dtTxt!);
                                if (date.day == DateTime.now().day) {
                                  String formattedTime =
                                      DateFormat('h:mm a').format(date);
                                  String formattedDate =
                                      DateFormat('E d').format(date);

                                  return Container(
                                    height: 140,
                                    width: 100,
                                    margin: const EdgeInsets.all(8),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey.shade800
                                          .withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          formattedTime,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                        Image.network(
                                          'https://openweathermap.org/img/w/${snapshot.data![i].weather![0].icon}.png',
                                          width: 40,
                                          height: 40,
                                        ),
                                        Text(
                                          '${snapshot.data![i].main!.temp!.toStringAsFixed(0)} °C',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                        Text(
                                          formattedDate,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ),
                        );
                      }
                    },
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
