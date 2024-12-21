import 'package:http/http.dart';

class ApiService {

  static Future<Response> getRandomJoke() async {
    var response = await get(Uri.parse("https://official-joke-api.appspot.com/random_joke"));
    return response;
  }

  static Future<Response> getJokeTypes() async {
    var response = await get(Uri.parse("https://official-joke-api.appspot.com/types"));
    return response;
  }

  static Future<Response> getJokeWithType(String type) async {
    final response = await get(Uri.parse("https://official-joke-api.appspot.com/jokes/$type/ten"));
    if (response.statusCode == 200) {
      return response;
    }
    else{
      throw Exception("Failed to load data!");
    }
  }
}