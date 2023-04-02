class Playlist {
  final String id;
  final String title;
  final String thumbnail;
  final String author;
  final String authorId;
  final int songCount;

  Playlist({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.author,
    required this.authorId,
    required this.songCount,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['playlistId'],
      title: json['title'],
      thumbnail: json['playlistThumbnail'],
      author: json['author'],
      authorId: json['authorId'],
      songCount: json['videoCount'],
    );
  }
}
