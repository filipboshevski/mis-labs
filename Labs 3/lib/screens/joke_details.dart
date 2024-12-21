import 'package:flutter/material.dart';

import '../models/Joke.dart';

class JokeDetails extends StatefulWidget {
  final Joke joke;
  const JokeDetails({super.key, required this.joke});

  @override
  State<JokeDetails> createState() => _JokeDetailsState();
}

class _JokeDetailsState extends State<JokeDetails> {

  @override
  Widget build(BuildContext context) {
    var joke = widget.joke;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Joke'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              joke.setup,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              joke.punchline,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
          ],
        ),
      )
    );
  }
}