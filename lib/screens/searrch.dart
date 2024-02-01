// search_screen.dart
import 'package:flutter/material.dart';
import 'package:weather_application/models/city_search_model.dart';
import 'package:weather_application/services/weather_services.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search';

  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  WeatherService weatherService = WeatherService();
  List<CitySearchModel> searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: _searchController,
          cursorColor: Colors.black,
          style: const TextStyle(color: Colors.black),
          decoration: const InputDecoration(
            hintText: 'Search city...',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            // searchCities(value);

            if (value.isEmpty) {
              searchResults.clear();
              setState(() {});
              return;
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              _searchController.clear();
              searchResults.clear();
              setState(() {});
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CityDetailScreen(
                    cityWeather: searchResults[index],
                  ),
                ),
              );
            },
            child: Card(
              child: ListTile(
                title: Text(
                  searchResults[index].name ?? '',
                  style: const TextStyle(
                      fontWeight: FontWeight.w200, color: Colors.black),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // void searchCities(String query) async {
//     if (query.isEmpty) {
//       searchResults.clear();
//       setState(() {});
//       return;
//     }

//     try {
//       List<CitySearchModel> results = await weatherService.searchCities(query);
//       searchResults = results;
//       setState(() {});
//     } catch (error) {
//       print('Error searching cities: $error');
//     }
//   }
// }
}

class CityDetailScreen extends StatelessWidget {
  final CitySearchModel cityWeather;

  const CityDetailScreen({super.key, required this.cityWeather});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cityWeather.name ?? ''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weather in ${cityWeather.name}:',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              '${cityWeather.main?.temp} °C',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // Add more fields as needed
          ],
        ),
      ),
    );
  }
}
