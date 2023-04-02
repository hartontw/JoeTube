class Episode {
  final String guid;
  final String title;
  final String description;
  final String image;
  final DateTime published;
  final String enclosure;
  final Duration duration;
  final String podcast;
  final String podcastLink;

  Episode(this.guid, this.title, this.description, this.image, this.published,
      this.enclosure, this.duration, this.podcast, this.podcastLink);
}
