import 'package:joetube/models/song_model.dart';

class AudioService {
  final List<Song> _history = [];

  AudioService(this._maxHistory);

  int _maxHistory;
  int get maxHistory => _maxHistory;
  set maxHistory(int maxHistory) {
    _maxHistory = maxHistory;
    int overflow = _history.length - maxHistory;
    if (overflow > 0) {
      _history.removeRange(0, overflow);
    }
  }
}
