import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../models/movie.dart';
import 'MovieDetailScreen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MovieProvider>(context);
    final favorites = provider.favorites;

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          ' Favorite Movies',
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: favorites.isEmpty
          ? const Center(
              child: Text(
                'No favorites yet.',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(
                  top: 130, left: 16, right: 16, bottom: 20),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final movie = favorites[index];
                final imageUrl = movie.posterPath.isNotEmpty
                    ? 'https://image.tmdb.org/t/p/w200${movie.posterPath}'
                    : 'https://via.placeholder.com/100x150?text=No+Image';

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border:
                        Border.all(color: Colors.redAccent.withOpacity(0.4)),
                    color: Colors.grey[900]?.withOpacity(0.4),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MovieDetailScreen(movie: movie),
                        ),
                      );
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                          child: Image.network(
                            imageUrl,
                            width: 100,
                            height: 150,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image,
                                    color: Colors.redAccent, size: 50),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movie.title.isNotEmpty
                                      ? movie.title
                                      : 'Untitled',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  movie.overview.length > 100
                                      ? '${movie.overview.substring(0, 100)}...'
                                      : movie.overview,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.redAccent),
                                    onPressed: () {
                                      provider.removeFromFavorites(movie.id);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
