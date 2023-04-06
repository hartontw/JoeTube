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

  String toFile() {
    return '''
    {
      "id": "$id",
      "name": "${name.replaceAll('"', '\\"')}",
      "description": "${description.replaceAll('"', '\\"')}",
      "thumbnails": ${thumbnails.toFile()},
      "verified": $verified
    }
    ''';
  }

  factory Channel.fromFile(Map<String, dynamic> json) {
    return Channel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      thumbnails: Thumbnails.fromFile(json['thumbnails']),
      verified: json['verified'],
    );
  }

  factory Channel.fromApi(Map<String, dynamic> json) {
    var thumbnails = json['authorThumbnails'] as List;
    return Channel(
      id: json['authorId'],
      name: json['author'],
      description: json['description'],
      thumbnails: Thumbnails.fromApi(thumbnails),
      verified: json['authorVerified'],
    );
  }
}
