class Thumbnails {
  static const int HIGH_LENGTH = 262144;
  static const int MEDIUM_LENGTH = 65536;
  static const int LOW_LENGTH = 16384;

  final String low;
  final String medium;
  final String high;

  Thumbnails({required this.low, required this.medium, required this.high});

  String toJson() {
    return '''
    [
      {
        "url": "$low",
        "width": 120,
        "height": 90
      },
      {
        "url": "$medium",
        "width": 320,
        "height": 180
      },
      {
        "url": "$high",
        "width": 480,
        "height": 360
      }
    ]
    ''';
  }

  factory Thumbnails.fromJson(List ts) {
    if (ts.isEmpty) throw Exception('Thumbnails not found');

    if (ts.length == 1) {
      return Thumbnails(
        low: ts.first['url'],
        medium: ts.first['url'],
        high: ts.first['url'],
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
      return desired;
    }

    return Thumbnails(
      low: getDesired(LOW_LENGTH),
      medium: getDesired(MEDIUM_LENGTH),
      high: getDesired(HIGH_LENGTH),
    );
  }
}
