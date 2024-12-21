import 'package:flutter/material.dart';

import '../models/Joke.dart';
import 'joke_details.dart';

class FavoriteJokes extends StatefulWidget {

  const FavoriteJokes({super.key});

  @override
  State<FavoriteJokes> createState() => _FavoriteJokesState();
}

class _FavoriteJokesState extends State<FavoriteJokes> {
  late Future<List<Joke>> jokes = Future.value([]);

  @override
  void initState() {
    super.initState();
    loadJokes();
  }

  Future<void> loadJokes() async {
    final jokes = await JokeDatabase.instance.getFavoriteJokes();

    setState(() {
      this.jokes = Future.value(jokes);
    });
  }

  Future<void> onFavoriteClicked(Joke joke) async {
    await JokeDatabase.instance.deleteJoke(joke.id);

    var jokes = Future.value((await this.jokes).where((j) => j.id != joke.id).toList());

    setState(() {
      this.jokes = jokes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Jokes'),
      ),
      body: FutureBuilder<List<Joke>>(
        future: jokes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  jokeData.type[0].toUpperCase() + jokeData.type.substring(1).toLowerCase(),
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                                IconButton(onPressed: () => { onFavoriteClicked(jokeData) }, icon: Icon(jokeData.isFavorite ? Icons.favorite : Icons.favorite_border_outlined), color: jokeData.isFavorite ? Colors.red : Colors.grey)
                              ],
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
            return const Center(child: Text('You\'re out of luck. No favorite jokes yet'));
          }
        },
      ),
    );
  }
}
