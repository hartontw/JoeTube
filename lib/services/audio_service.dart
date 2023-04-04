import 'package:joetube/class/song_collection.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../models/song_model.dart';

class AudioService {
  AudioService(this._maxHistory);

  final YoutubeExplode _yt = YoutubeExplode();
  final AudioPlayer _player = AudioPlayer();
  final SongCollection _collection = SongCollection();
  final List<Song> _history = [];

  late int _maxHistory;
  int get maxHistory => _maxHistory;
  set maxHistory(int maxHistory) {
    _maxHistory = maxHistory;
    int overflow = _history.length - maxHistory;
    if (overflow > 0) {
      _history.removeRange(0, overflow);
    }
  }

  void _addToHistory(Song song) {
    int index = _history.indexWhere((e) => e.id == song.id);
    if (index >= 0) {
      _history.removeAt(index);
    }
    _history.add(song);

    if (_history.length > _maxHistory) {
      _history.removeAt(0);
    }
  }

  Future<AudioSource> _getSource(Song song) async {
    var manifest = await _yt.videos.streamsClient.getManifest(song.id);
    var stream = manifest.audioOnly.withHighestBitrate().url.toString();
    return AudioSource.uri(Uri.parse(stream),
        tag: MediaItem(
          id: song.id,
          title: song.title,
          artist: song.author,
          artUri: Uri.parse(
            song.thumbnails.medium,
          ),
        ));
  }
}
