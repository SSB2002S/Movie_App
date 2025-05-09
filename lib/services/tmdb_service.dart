// TODO Implement this library.import 'dart:convert';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class TMDBService {
  final String _apiKey = 'ab2d2b9e95a4b4a3a25ebc51bb070279';

  Future<List<String>> getCast(int movieId) async {
    final url = 'https://api.themoviedb.org/3/movie/$movieId/credits?api_key=$_apiKey';
    final res = await http.get(Uri.parse(url));
    final data = jsonDecode(res.body);
    return List<String>.from(data['cast'].take(10).map((actor) => actor['name']));
  }

  Future<List<Movie>> getSimilarMovies(int movieId) async {
    final url = 'https://api.themoviedb.org/3/movie/$movieId/similar?api_key=$_apiKey';
    final res = await http.get(Uri.parse(url));
    final data = jsonDecode(res.body);
    return List<Movie>.from(data['results'].map((m) => Movie.fromJson(m)));
  }
}
