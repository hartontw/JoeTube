import 'podcast_model.dart';

abstract class PodcastSearchItem {
  final String title;
  final String thumbnail;
  final String url;

  PodcastSearchItem(this.title, this.thumbnail, this.url);

  Future<Podcast> parse();
}
