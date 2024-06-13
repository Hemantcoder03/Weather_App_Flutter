import 'package:flutter/material.dart';

class AdditionalInfoItem extends StatelessWidget {
  const AdditionalInfoItem(this.icon, this.infoTitle, this.infoValue,
      {super.key});

  final IconData icon;
  final String infoTitle;
  final String infoValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 30,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          infoTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          infoValue,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
