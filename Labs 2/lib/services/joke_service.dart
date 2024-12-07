import 'dart:convert';

import 'package:lab2/models/Joke.dart';
import 'package:lab2/services/api_service.dart';

class JokeService {
  static Future<Joke> getRandomJoke() async {
    var response = await ApiService.getRandomJoke();
    var data = json.decode(response.body);

    return Joke(id: data['id'],
        type: data['type'],
        setup: data['setup'],
        punchline: data['punchline']);
  }

  static Future<List<Joke>> getJokesFromType(String type) async {
    var response = await ApiService.getJokeWithType(type);
    var data = json.decode(response.body);

    return data.map<Joke>((j) => Joke(id: j['id'], type: j['type'], setup: j['setup'], punchline: j['punchline'])).toList();
  }

  static Future<List<String>> getJokeTypes() async {
    var response = await ApiService.getJokeTypes();
    var data = json.decode(response.body);

    return data.map<String>((t) => t.toString()).toList();
  }
}