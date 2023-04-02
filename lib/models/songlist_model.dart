import 'song_model.dart';

class SongListModel {
  SongListModel(this.name);

  late String name;

  final List<Song> _songs = [];
  List<Song> get songs => _songs;

  void addSong(Song song) {
    _songs.add(song);
  }

  String toJson() {
    var json = '''
    {
      "name": "$name",
      "songs": [
        ${_songs.map((song) => song.toJson()).join(',')}
      ]
    }
    ''';
    return json;
  }

  void writeToFile() {}

  factory SongListModel.fromJson(Map<String, dynamic> json) {
    var songs = json['songs'] as List;
    var songList = SongListModel(json['name']);
    for (var song in songs) {
      songList.addSong(Song.fromJson(song));
    }
    return songList;
  }

  factory SongListModel.fromFile(String path) {
    return SongListModel.fromJson({});
  }
}
