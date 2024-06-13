import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/items/additional_info_item.dart';
import 'package:weather_app/items/hourly_forecast_item.dart';
import 'package:weather_app/secret_data.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  Future getCurrentWeather() async {
    const cityName = "Bhiwandi";

    try {
      final res = await http.get(Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$apiKey"));

      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw 'An unknown error executed';
      }

      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          InkWell(
            child: IconButton(
              onPressed: () {
                setState(() {
                  getCurrentWeather();
                });
              },
              icon: const Icon(Icons.refresh_rounded),
            ),
          )
        ],
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          //set the progress bar when data is loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Text(
              snapshot.error.toString(),
            );
          }

          final data = snapshot.data!;

          final currentMain = data['list'][0]['main'];
          final currentTemp = currentMain['temp'];
          final currentWeather = data['list'][0]['weather'][0]['main'];
          final currentPressure = currentMain['pressure'];
          final currentWindSpeed = data['list'][0]['wind']['speed'];
          final currentHumidity = currentMain['humidity'];

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 5,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(16),
                      ),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 3,
                        sigmaY: 3,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "$currentTemp K",
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Icon(
                              currentWeather == "Clouds" ||
                                      currentWeather == "Rain"
                                  ? Icons.cloud
                                  : Icons.sunny,
                              size: 45,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              currentWeather,
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Hourly Forecast",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 155,
                  child: ListView.builder(
                    itemCount: 5,
                    padding: const EdgeInsets.all(10),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final hourlyForecast = data['list'][index + 1]['dt_txt'];
                      final forecastWeather =
                          data['list'][index + 1]['weather'][0]['main'];
                      final forecastTemp =
                          data['list'][index + 1]['main']['temp'];

                      //format time using an intl dependency
                      final time =
                          DateFormat.j().format(DateTime.parse(hourlyForecast));

                      return HourlyForecastItem(
                          time.toString(),
                          forecastWeather == "Clouds" ||
                                  forecastWeather == "Rain"
                              ? Icons.cloud
                              : Icons.sunny,
                          forecastTemp.toString());
                    },
                    // ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Additional Information",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 7,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfoItem(Icons.water_drop, "Humidity",
                        currentHumidity.toString()),
                    AdditionalInfoItem(Icons.wind_power_rounded, "Wind Speed",
                        currentWindSpeed.toString()),
                    AdditionalInfoItem(Icons.beach_access, "Pressure",
                        currentPressure.toString()),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
