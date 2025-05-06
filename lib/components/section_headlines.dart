import 'package:flutter/material.dart';
import 'package:intracake/components/cake_card.dart';
import 'package:intracake/public/colors.dart';
import 'package:intracake/components/section.dart';

Widget buildCakeSection(Section section) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        section.title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.brown,
        ),
      ),
      if (section.subTitle != null)
        Text(
          section.subTitle!,
          style: const TextStyle(
            fontSize: 14,
            color: neutral700,
          ),
        ),
      const SizedBox(height: 12),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: section.items.map((cake) {
            return buildCakeCard(cake);
          }).toList(),
        ),
      ),
      const SizedBox(height: 24),
    ],
  );
}
