import 'package:flutter/material.dart';

class HourlyForecastItem extends StatelessWidget {
  final String hour;
  final IconData forecastIcon;
  final String forecastTemp;

  const HourlyForecastItem(this.hour, this.forecastIcon, this.forecastTemp,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                hour,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Icon(
                forecastIcon,
                size: 30,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                forecastTemp,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
