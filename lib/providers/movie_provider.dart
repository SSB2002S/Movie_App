import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/movie_api_service.dart';
import '../database/favorites_db.dart';

class MovieProvider extends ChangeNotifier {
  late Future<List<Movie>> _trendingMovies;
  late Future<List<Movie>> _tvShows;
  late Future<List<Movie>> _airingTodayTVShows;
  List<Movie> _favorites = [];

  MovieProvider() {
    fetchMovies();
    fetchTVShows();
    fetchAiringTodayTVShows();
    loadFavorites();
  }

  Future<List<Movie>> get trendingMovies => _trendingMovies;
  Future<List<Movie>> get tvShows => _tvShows;
  Future<List<Movie>> get airingTodayTVShows => _airingTodayTVShows;
  List<Movie> get favorites => _favorites;

  void fetchMovies() {
    _trendingMovies = MovieApiService.fetchTrendingMovies();
    notifyListeners();
  }

  void fetchTVShows() {
    _tvShows = MovieApiService.fetchTVShows();
    notifyListeners();
  }

  void fetchAiringTodayTVShows() {
    _airingTodayTVShows = MovieApiService.fetchAiringTodayTVShows();
    notifyListeners();
  }

  Future<void> addToFavorites(Movie movie) async {
    await FavoritesDB.addFavorite(movie);
    await loadFavorites();
  }

  Future<void> removeFromFavorites(int id) async {
    await FavoritesDB.removeFavorite(id);
    await loadFavorites();
  }

  Future<void> loadFavorites() async {
    _favorites = await FavoritesDB.getFavorites();
    notifyListeners();
  }

  bool isFavorite(int movieId) {
    return _favorites.any((movie) => movie.id == movieId);
  }
}
