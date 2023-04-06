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

  String toFile() {
    return '''
    {
      "id": "$id",
      "title": "${title.replaceAll('"', '\\"')}",
      "thumbnail": "$thumbnail",
      "author": "${author.replaceAll('"', '\\"')}",
      "authorId": "$authorId",
      "songCount": $songCount
    }
    ''';
  }

  factory Playlist.fromFile(Map<String, dynamic> json) {
    return Playlist(
      id: json['id'],
      title: json['title'],
      thumbnail: json['thumbnail'],
      author: json['author'],
      authorId: json['authorId'],
      songCount: json['songCount'],
    );
  }

  factory Playlist.fromApi(Map<String, dynamic> json) {
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
