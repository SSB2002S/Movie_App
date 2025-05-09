import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class MovieApiService {
  static const String _apiKey = 'ab2d2b9e95a4b4a3a25ebc51bb070279';
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  static Future<List<Movie>> fetchTrendingMovies() async {
    final url = Uri.parse('$_baseUrl/trending/movie/week?api_key=$_apiKey');
    final response = await http.get(url);
    

    if (response.statusCode == 200) {
      final List results = json.decode(response.body)['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('❌ Failed to load trending movies');
    }
  }

  static Future<List<Movie>> fetchTVShows() async {
    final url = Uri.parse('$_baseUrl/tv/popular?api_key=$_apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List results = json.decode(response.body)['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('❌ Failed to load TV shows');
    }
  }

  static Future<List<Movie>> fetchAiringTodayTVShows() async {
    final url = Uri.parse('$_baseUrl/tv/airing_today?api_key=$_apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List results = json.decode(response.body)['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('❌ Failed to load airing today shows');
    }
  }

  static Future<void> deleteFavoriteShow(int showId) async {
    
    await Future.delayed(const Duration(seconds: 1));
    
    print('✅ Simulated deletion of show with ID $showId from server.');
    
    return;
  }
}

