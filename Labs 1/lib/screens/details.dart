import 'package:flutter/material.dart';
import 'package:labs1/models/clothing_item.dart';

class DetailsScreen extends StatelessWidget {
  final ClothingItem item;

  const DetailsScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              item.image,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            Text(
              item.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              '${item.price} ден',
              style: const TextStyle(fontSize: 20, color: Colors.black),
            ),
            const SizedBox(height: 20),
            Text(
              item.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}