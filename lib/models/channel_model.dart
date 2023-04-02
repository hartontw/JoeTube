import 'thumbnails_model.dart';

class Channel {
  final String id;
  final String name;
  final String description;
  final Thumbnails thumbnails;
  final bool verified;

  Channel({
    required this.id,
    required this.name,
    required this.description,
    required this.thumbnails,
    required this.verified,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    var thumbnails = json['authorThumbnails'] as List;
    return Channel(
      id: json['authorId'],
      name: json['author'],
      description: json['description'],
      thumbnails: Thumbnails.fromJson(thumbnails),
      verified: json['authorVerified'],
    );
  }
}
