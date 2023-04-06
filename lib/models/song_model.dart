import 'thumbnails_model.dart';

class Song {
  final String id;
  final String title;
  final Thumbnails thumbnails;
  final Duration duration;
  final String author;
  final String authorId;

  Song({
    required this.id,
    required this.title,
    required this.thumbnails,
    required this.duration,
    required this.author,
    required this.authorId,
  });

  String toFile() {
    return '''
    {
      "id": "$id",
      "title": "${title.replaceAll('"', '\\"')}",
      "duration": ${duration.inSeconds},
      "author": "${author.replaceAll('"', '\\"')}",
      "authorId": "$authorId"
    }
    ''';
  }

  factory Song.fromFile(Map<String, dynamic> json) {
    return Song(
      id: json['id'],
      title: json['title'],
      thumbnails: Thumbnails.fromSongId(json['id']),
      duration: Duration(seconds: json['duration']),
      author: json['author'],
      authorId: json['authorId'],
    );
  }

  factory Song.fromApi(Map<String, dynamic> json) {
    var thumbnails = json['videoThumbnails'] as List;
    if (thumbnails.length == 1) {
      if (thumbnails[0] is List) {
        thumbnails = thumbnails[0] as List;
      }
    }
    return Song(
      id: json['videoId'],
      title: json['title'],
      thumbnails: Thumbnails.fromApi(thumbnails),
      duration: Duration(seconds: json['lengthSeconds']),
      author: json['author'],
      authorId: json['authorId'],
    );
  }
}
