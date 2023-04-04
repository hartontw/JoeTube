import '../models/song_model.dart';

class AudioService {
  int _maxHistory;

  AudioService(this._maxHistory);

  final List<Song> _history = [];

  int get maxHistory => _maxHistory;
  set maxHistory(int maxHistory) {
    _maxHistory = maxHistory;
    int overflow = _history.length - maxHistory;
    if (overflow > 0) {
      _history.removeRange(0, overflow);
    }
  }
}
