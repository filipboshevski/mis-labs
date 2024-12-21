import 'package:flutter/material.dart';
import 'package:lab2/screens/favorite_jokes.dart';
import 'package:lab2/screens/joke_details.dart';
import 'package:lab2/screens/jokes_by_type.dart';
import 'package:lab2/services/joke_service.dart';
import 'package:lab2/widgets/text_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  List<String> jokeTypes = [];

  @override
  void initState() {
    super.initState();
    getJokeTypes();
  }

  void getJokeTypes() async {
    var jokeTypes = await JokeService.getJokeTypes();
    setState(() {
      this.jokeTypes = jokeTypes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('211092')
      ),
      body: jokeTypes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Column(
                  children: [
                    CustomTextButton(
                      text: 'Get a random joke of the day',
                      tooltip: 'Get a random joke of the day',
                      onPressed: () async {
                        var randomJoke = await JokeService.getRandomJoke();

                        if (!mounted) return;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JokeDetails(joke: randomJoke),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextButton(
                      text: 'Favorite Jokes',
                      tooltip: 'Favorite Jokes',
                      onPressed: () async {
                        if (!mounted) return;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FavoriteJokes(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: jokeTypes.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: ListTile(
                          title: Text(
                            jokeTypes[index],
                            style: const TextStyle(fontSize: 18),
                          ),
                          leading: const Icon(Icons.tag_faces),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => JokesByType(
                                  jokeType: jokeTypes[index],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
