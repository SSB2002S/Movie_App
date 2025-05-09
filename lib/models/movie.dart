class Movie {
  final int id;
  final String title;
  final String posterPath;
  final String overview;

  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
  });
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'] ?? json['name'] ?? 'No Title',
      posterPath: json['poster_path'] ?? '',
      overview: json['overview'] ?? '',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'posterPath': posterPath,
      'overview': overview,
    };
  }

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'],
      title: map['title'],
      posterPath: map['posterPath'],
      overview: map['overview'],
    );
  }
}
