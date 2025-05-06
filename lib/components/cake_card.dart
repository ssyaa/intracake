import 'package:flutter/material.dart';
import 'package:intracake/models/cake.dart';  // Pastikan ini diimpor

Widget buildCakeCard(Cake cake) {
  return Container(
    width: 200,
    margin: const EdgeInsets.only(right: 16, bottom: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: const Color.fromARGB(51, 158, 158, 158),
          spreadRadius: 1,
          blurRadius: 3,
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
          child: Image.asset(
            cake.imagePath,
            height: 120,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 120,
                color: Colors.grey[300],
                child: const Center(child: Icon(Icons.image, size: 50)),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      cake.name,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getCardDifficultyColor(cake.difficulty),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      cake.difficulty,
                      style: TextStyle(
                        color: _getTextDifficultyColor(cake.difficulty),
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.favorite, color: Colors.red, size: 16),
                  const SizedBox(width: 4),
                  Text('${cake.favorites} pengguna lainnya', style: const TextStyle(fontSize: 12)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text('${cake.rating}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.grey, size: 16),
                      const SizedBox(width: 4),
                      Text('${cake.estimationTime} menit', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Color _getCardDifficultyColor(String difficulty) {
  switch (difficulty) {
    case 'Easy':
      return Colors.green.shade50;
    case 'Medium':
      return Colors.amber.shade50;
    case 'Hard':
      return Colors.red.shade50;
    default:
      return Colors.grey.shade50;
  }
}

Color _getTextDifficultyColor(String difficulty) {
  switch (difficulty) {
    case 'Easy':
      return Colors.green.shade900;
    case 'Medium':
      return Colors.amber.shade900;
    case 'Hard':
      return Colors.red.shade900;
    default:
      return Colors.grey.shade900;
  }
}
