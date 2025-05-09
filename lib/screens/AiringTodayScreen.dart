import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import '../providers/movie_provider.dart';
import '../services/movie_api_service.dart';
import 'MovieDetailScreen.dart';

class AiringTodayScreen extends StatefulWidget {
  const AiringTodayScreen({super.key});

  @override
  State<AiringTodayScreen> createState() => _AiringTodayScreenState();
}

class _AiringTodayScreenState extends State<AiringTodayScreen> {
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
    final movieProvider = Provider.of<MovieProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
            color: Colors.black,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: Text(
                    '📺 Airing Today',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    onChanged: (query) async {
                      final shows = await movieProvider.airingTodayTVShows;
                      _filterShows(query, shows);
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Search shows...',
                      hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 20,
                      ), 
                      prefixIcon: Icon(Icons.search, color: Colors.redAccent),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: FutureBuilder<List<Movie>>(
              future: movieProvider.airingTodayTVShows,
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
                      'No shows airing today.',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                } else {
                  final shows =
                      searchQuery.isEmpty ? snapshot.data! : filteredShows;

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: shows.length,
                    itemBuilder: (context, index) {
                      final show = shows[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
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
                                        show.overview.isNotEmpty
                                            ? (show.overview.length > 100
                                                ? '${show.overview.substring(0, 100)}...'
                                                : show.overview)
                                            : 'No description available.',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white70,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Consumer<MovieProvider>(
                                            builder: (context, provider, _) {
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
                                                onPressed: () async {
                                                  if (isFav) {
                                                    provider
                                                        .removeFromFavorites(
                                                          show.id,
                                                        );
                                                    try {
                                                      await MovieApiService.deleteFavoriteShow(
                                                        show.id,
                                                      );
                                                    } catch (e) {
                                                      ScaffoldMessenger.of(
                                                        context,
                                                      ).showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                            'Failed to delete from server',
                                                          ),
                                                          backgroundColor:
                                                              Colors.red,
                                                        ),
                                                      );
                                                    }
                                                  } else {
                                                    provider.addToFavorites(
                                                      show,
                                                    );
                                                  }
                                                },
                                              );
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.white70,
                                            ),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (context) => AlertDialog(
                                                      title: const Text(
                                                        'Delete Show',
                                                      ),
                                                      content: const Text(
                                                        'Are you sure you want to delete this show?',
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          child: const Text(
                                                            'Cancel',
                                                          ),
                                                          onPressed:
                                                              () =>
                                                                  Navigator.of(
                                                                    context,
                                                                  ).pop(),
                                                        ),
                                                        TextButton(
                                                          child: const Text(
                                                            'Delete',
                                                          ),
                                                          onPressed: () async {
                                                            try {
                                                              await MovieApiService.deleteFavoriteShow(
                                                                show.id,
                                                              );
                                                              ScaffoldMessenger.of(
                                                                context,
                                                              ).showSnackBar(
                                                                const SnackBar(
                                                                  content: Text(
                                                                    'Show deleted successfully',
                                                                    style: TextStyle(
                                                                      color:
                                                                          Colors
                                                                              .white,
                                                                    ),
                                                                  ),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .green,
                                                                ),
                                                              );
                                                              setState(() {
                                                                filteredShows
                                                                    .removeWhere(
                                                                      (
                                                                        element,
                                                                      ) =>
                                                                          element
                                                                              .id ==
                                                                          show.id,
                                                                    );
                                                              });
                                                            } catch (e) {
                                                              ScaffoldMessenger.of(
                                                                context,
                                                              ).showSnackBar(
                                                                const SnackBar(
                                                                  content: Text(
                                                                    'Failed to delete from server',
                                                                  ),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                ),
                                                              );
                                                            }
                                                            Navigator.of(
                                                              context,
                                                            ).pop();
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                              );
                                            },
                                          ),
                                        ],
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
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
