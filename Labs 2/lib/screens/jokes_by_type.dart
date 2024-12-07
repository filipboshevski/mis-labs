import 'package:flutter/material.dart';
import 'package:lab2/services/joke_service.dart';

import '../models/Joke.dart';
import 'joke_details.dart';

class JokesByType extends StatefulWidget {
  final String jokeType;

  const JokesByType({super.key, required this.jokeType});

  @override
  State<JokesByType> createState() => _JokesByTypeState();
}

class _JokesByTypeState extends State<JokesByType> {
  late Future<List<Joke>> jokes;

  @override
  void initState() {
    super.initState();

    setState(() {
      jokes = JokeService.getJokesFromType(widget.jokeType);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.jokeType[0].toUpperCase() + widget.jokeType.substring(1).toLowerCase()} Jokes'),
      ),
      body: FutureBuilder<List<Joke>>(
        future: jokes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final jokesList = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: jokesList.length,
                itemBuilder: (context, index) {
                  final jokeData = jokesList[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: InkWell(
                      onTap: () {
                        if (!mounted) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JokeDetails(joke: jokeData),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              jokeData.type[0].toUpperCase() + jokeData.type.substring(1).toLowerCase(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              jokeData.setup,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              jokeData.punchline,
                              style: const TextStyle(
                                fontSize: 20,
                                fontStyle: FontStyle.italic,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return Center(child: Text('You\'re out of luck. No ${widget.jokeType} jokes yet'));
          }
        },
      ),
    );
  }
}
