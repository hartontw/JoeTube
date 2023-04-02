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

  factory Song.fromJson(Map<String, dynamic> json) {
    var thumbnails = json['videoThumbnails'] as List;
    if (thumbnails.length == 1) {
      if (thumbnails[0] is List) {
        thumbnails = thumbnails[0] as List;
      }
    }
    return Song(
      id: json['videoId'],
      title: json['title'],
      thumbnails: Thumbnails.fromJson(thumbnails),
      duration: Duration(seconds: json['lengthSeconds']),
      author: json['author'],
      authorId: json['authorId'],
    );
  }
}
