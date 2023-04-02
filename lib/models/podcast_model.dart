//https://gist.github.com/iggym/6023041

import 'episode_model.dart';

class Podcast {
  final String link; //id
  final String title;
  final String description;
  final String image;
  final String author;
  final String language;
  final List<String> categories;
  final List<Episode> episodes;

  Podcast(
    this.link,
    this.title,
    this.description,
    this.image,
    this.author,
    this.language,
    this.categories,
    this.episodes,
  );

  factory Podcast.fromFeed(Map<String, dynamic> json) {
    return Podcast(
      json['link'],
      json['title'],
      json['description'],
      json['image'],
      json['author'],
      json['language'],
      json['categories'],
      json['episodes'],
    );
  }
}
