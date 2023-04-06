class Thumbnails {
  static const int HIGH_LENGTH = 262144;
  static const int MEDIUM_LENGTH = 65536;
  static const int LOW_LENGTH = 16384;

  final String low;
  final String medium;
  final String high;

  Thumbnails({required this.low, required this.medium, required this.high});

  String toFile() {
    return '''
    {
      "low": "$low",
      "medium": "$medium",
      "high": "$high"
    }
    ''';
  }

  factory Thumbnails.fromSongId(String id) {
    const String BASE_URL = 'https://i.ytimg.com/vi';
    return Thumbnails(
      low: '$BASE_URL/$id/default.jpg',
      medium: '$BASE_URL/$id/mqdefault.jpg',
      high: '$BASE_URL/$id/hqdefault.jpg',
    );
  }

  factory Thumbnails.fromFile(Map<String, dynamic> json) {
    return Thumbnails(
      low: json['low'],
      medium: json['medium'],
      high: json['high'],
    );
  }

  factory Thumbnails.fromApi(List ts) {
    if (ts.isEmpty) throw Exception('Thumbnails not found');

    String format(String url) {
      return url.startsWith('//') ? 'https:$url' : url;
    }

    if (ts.length == 1) {
      final String url = format(ts.first['url']);
      return Thumbnails(
        low: url,
        medium: url,
        high: url,
      );
    }

    int getDiff(dynamic item, int desired) =>
        (item['width'] * item['height'] - desired).abs();

    String getDesired(int desiredLength) {
      String desired = ts[0]['url'];
      int min = getDiff(ts.first, desiredLength);
      for (int i = 1; i < ts.length; i++) {
        int d = getDiff(ts[i], desiredLength);
        if (d < min) {
          min = d;
          desired = ts[i]['url'];
        }
      }
      return format(desired);
    }

    return Thumbnails(
      low: getDesired(LOW_LENGTH),
      medium: getDesired(MEDIUM_LENGTH),
      high: getDesired(HIGH_LENGTH),
    );
  }
}
