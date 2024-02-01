import 'package:flutter/material.dart';

class SavedLocation extends StatelessWidget {
  const SavedLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0XFF261A49),
                Color(0XFF301D5C),
                Color(0XFF262171),
                Color(0XFF301D5C),
                Color(0XFF381A4B),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: Column(
              children: [
                Text(
                  'Saved Locations',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) {
                      return const SavedWeatherCard();
                    },
                  ),
                ),
                // GestureDetector(
                //   onTap: () {},
                //   child: Container(
                //     height: 50,
                //     width: double.infinity,
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(20),
                //       color: Colors.transparent.withOpacity(0.2),
                //     ),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         const Icon(Icons.add_circle_outline),
                //         const SizedBox(width: 10),
                //         Text(
                //           'Add new',
                //           style: Theme.of(context).textTheme.bodyLarge,
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SavedWeatherCard extends StatelessWidget {
  const SavedWeatherCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          // color: Color(0XFFAAA5A5).withOpacity(0.3),
          color: Colors.transparent.withOpacity(0.2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'New York',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  Text(
                    'Haze',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const Expanded(child: SizedBox()),
                  Row(
                    children: [
                      Text(
                        'Humidity ',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        '56% ',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Wind',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        ' 5.14 km/h',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(
                    Icons.wb_cloudy,
                    size: 36,
                  ),
                  Text(
                    '24 C',
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge!
                        .copyWith(fontWeight: FontWeight.w900, fontSize: 36),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
