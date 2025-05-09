import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/tmdb_service.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          movie.title,
          style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              'Overview',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(movie.overview, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 24),

            FutureBuilder<List<String>>(
              future: TMDBService().getCast(movie.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cast',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children:
                          snapshot.data!
                              .map(
                                (actor) => Chip(
                                  label: Text(
                                    actor,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.redAccent.withOpacity(
                                    0.4,
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),

            FutureBuilder<List<Movie>>(
              future: TMDBService().getSimilarMovies(movie.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Similar Movies',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 150,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children:
                            snapshot.data!
                                .map(
                                  (m) => Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        'https://image.tmdb.org/t/p/w200${m.posterPath}',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
