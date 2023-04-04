import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:joetube/class/song_collection.dart';

import '../models/song_model.dart';

abstract class Storage {
  Future<void> saveSongCollection(SongCollection collection);
  Future<List<Song>> loadSongCollection(String name);
}

class FileStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}
