import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import '../providers/movie_provider.dart';
import 'moviedetailscreen.dart';

class TVShowsScreen extends StatefulWidget {
  const TVShowsScreen({super.key});

  @override
  State<TVShowsScreen> createState() => _TVShowsScreenState();
}

class _TVShowsScreenState extends State<TVShowsScreen> {
  String searchQuery = '';
  List<Movie> filteredShows = [];

  void _filterShows(String query, List<Movie> allShows) {
    final results =
        allShows
            .where(
              (show) => show.title.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
    setState(() {
      searchQuery = query;
      filteredShows = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<List<Movie>>(
        future: movieProvider.tvShows,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.redAccent),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No TV shows found.',
                style: TextStyle(color: Colors.white),
              ),
            );
          } else {
            final shows = searchQuery.isEmpty ? snapshot.data! : filteredShows;

            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    top: 50,
                    left: 16,
                    right: 16,
                    bottom: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        '📺 Popular TV Shows',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextField(
                          onChanged: (query) async {
                            final shows = await movieProvider.tvShows;
                            _filterShows(query, shows);
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'Search TV shows...',
                            hintStyle: TextStyle(color: Colors.white70),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 20,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: shows.length,
                    itemBuilder: (context, index) {
                      final show = shows[index];

                      return Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.redAccent.withOpacity(0.4),
                          ),
                          color: Colors.grey[900]?.withOpacity(0.4),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MovieDetailScreen(movie: show),
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
                                  show.posterPath.isNotEmpty
                                      ? 'https://image.tmdb.org/t/p/w200${show.posterPath}'
                                      : 'https://via.placeholder.com/100x150?text=No+Image',
                                  width: 100,
                                  height: 150,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          const Icon(
                                            Icons.broken_image,
                                            color: Colors.redAccent,
                                            size: 50,
                                          ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        show.title.isNotEmpty
                                            ? show.title
                                            : 'Untitled',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        show.overview.length > 100
                                            ? '${show.overview.substring(0, 100)}...'
                                            : show.overview,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white70,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Consumer<MovieProvider>(
                                          builder: (context, provider, child) {
                                            final isFav = provider.isFavorite(
                                              show.id,
                                            );
                                            return IconButton(
                                              icon: Icon(
                                                isFav
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color:
                                                    isFav
                                                        ? Colors.red
                                                        : Colors.redAccent,
                                              ),
                                              onPressed: () {
                                                if (isFav) {
                                                  provider.removeFromFavorites(
                                                    show.id,
                                                  );
                                                } else {
                                                  provider.addToFavorites(show);
                                                }
                                              },
                                            );
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
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
