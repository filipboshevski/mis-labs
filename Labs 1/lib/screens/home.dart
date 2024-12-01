import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/clothing_item.dart';
import 'details.dart';

final List<ClothingItem> clothingItems = [
  ClothingItem(
      "STUDIO ЈАКНА ПОЛНЕТА СО 100% ПЕРДУВИ И ПЕРЈЕ X ALL CAPS",
      "https://static.zara.net/assets/public/4ada/83ce/32fa491dbc59/31f1544e7bc8/06318499800-p/06318499800-p.jpg",
      "Полнета јакна изработена од текстурирана ripstop техничка ткаенина која е отпорна на кинење.",
      3390.0
  ),
  ClothingItem(
    "ФАРМЕРКИ RELAXED FIT",
    "https://static.zara.net/assets/public/b6c5/8765/cde54f8b94d3/0990699aea4e/06045302407-p/06045302407-p.jpg",
    "Избледени фармерки со опуштен крој и приспособлив струк со странични ленти, пет џеба, приспособливи долни рабови со лепенки и закопчување со патент и горно копче.",
    2590.0,
  ),
  ClothingItem(
      "ИЗБЛЕДЕНА ПЛЕТЕНА ПОЛО МАИЦА СО ТЕКСТУРА",
      "https://static.zara.net/assets/public/3273/a659/c93d43b290e1/bc8ec550116c/03284321611-a1/03284321611-a1.jpg?ts=1725978856769&w=1126",
      "Поло маица со опуштен крој и јака изработена од предена памучна ткаенина. Предно закопчување со патент, долги ракави и ребрести рабови.",
      2290.0
  )
];

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('211092'),
      ),
      body: ListView.builder(
        itemCount: clothingItems.length,
        itemBuilder: (context, index) {
          final item = clothingItems[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: Image.network(item.image),
              title: Text(item.name),
              subtitle: Text('${item.price.toString()} ден'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsScreen(item: item),
                  ),
                );
              },
            ),
          );
        },
      )
    );
  }
}