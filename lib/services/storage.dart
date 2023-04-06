import 'dart:io';
import 'dart:convert';

import '../models/channel_model.dart';
import '../models/playlist_model.dart';
import '../models/song_model.dart';

abstract class Storage {
  Future<List<String>> listSongCollections();
  Future<void> saveSongCollection(String name, List<Song> collection);
  Future<List<Song>> loadSongCollection(String name);
  Future<void> deleteSongCollection(String name);
  Future<void> renameSongCollection(String oldName, String newName);
  Future<void> addSongToCollection(String name, Song song);
  Future<void> removeSongFromCollection(String name, String id);
  Future<List<Song>> loadFavoriteSongs();
  Future<List<Channel>> loadFavoriteChannels();
  Future<List<Playlist>> loadFavoritePlaylists();
  Future<List<dynamic>> loadFavoritePodcasts();
  Future<List<dynamic>> loadFavoriteRadios();
  Future<void> saveFavoriteSongs(List<Song> songs);
  Future<void> addFavoriteSong(Song song);
  Future<void> removeFavoriteSong(String id);
  Future<void> saveFavoriteChannels(List<Channel> channels);
  Future<void> addFavoriteChannel(Channel channel);
  Future<void> removeFavoriteChannel(String id);
  Future<void> saveFavoritePlaylists(List<Playlist> playlists);
  Future<void> addFavoritePlaylist(Playlist playlist);
  Future<void> removeFavoritePlaylist(String id);
  Future<void> saveFavoritePodcasts(List<dynamic> podcasts);
  Future<void> saveFavoriteRadios(List<dynamic> radios);
  Future<void> clearFavoriteSongs();
  Future<void> clearFavoriteChannels();
  Future<void> clearFavoritePlaylists();
}

class FileStorage implements Storage {
  FileStorage(this.path);

  final String path;

  get collectionsPath {
    return '$path/collections';
  }

  get favoritesPath {
    return '$path/favorites';
  }

  Future<void> deleteDirectory() async {
    Directory dir = Directory(path);
    if (dir.existsSync()) {
      await dir.delete(recursive: true);
    }
  }

  @override
  Future<void> saveSongCollection(String name, List<Song> collection) async {
    Directory collectionsDir = Directory(collectionsPath);
    if (!collectionsDir.existsSync()) {
      collectionsDir.createSync(recursive: true);
    }
    final file = File('$collectionsPath/$name.json');
    String json = '[${collection.map((e) => e.toFile()).join(',')}]';
    await file.writeAsString(json);
  }

  @override
  Future<List<Song>> loadSongCollection(String name) async {
    Directory collectionsDir = Directory(collectionsPath);
    if (!collectionsDir.existsSync()) {
      throw Exception('Collections directory does not exist');
    }
    final file = File('$collectionsPath/$name.json');
    if (!file.existsSync()) {
      throw Exception('Collection $name does not exist');
    }
    String content = await file.readAsString();
    var songs = json.decode(content) as List;
    return songs.map((s) => Song.fromFile(s)).toList();
  }

  @override
  Future<void> renameSongCollection(String oldName, String newName) async {
    final file = File('$collectionsPath/$oldName.json');
    if (file.existsSync()) {
      await file.rename('$collectionsPath/$newName.json');
    }
  }

  @override
  Future<void> deleteSongCollection(String name) async {
    final file = File('$collectionsPath/$name.json');
    if (file.existsSync()) {
      await file.delete();
    }
  }

  @override
  Future<List<String>> listSongCollections() async {
    Directory collectionsDir = Directory(collectionsPath);
    if (!collectionsDir.existsSync()) {
      return [];
    }
    return collectionsDir
        .listSync()
        .map((e) => e.uri.pathSegments.last.replaceFirst(RegExp(r'\..+'), ''))
        .toList();
  }

  @override
  Future<List<Song>> loadFavoriteSongs() async {
    Directory favoritesDir = Directory(favoritesPath);
    if (!favoritesDir.existsSync()) {
      return [];
    }
    final file = File('$favoritesPath/songs.json');
    if (!file.existsSync()) {
      return [];
    }
    String content = await file.readAsString();
    var songs = json.decode(content) as List;
    return songs.map((s) => Song.fromFile(s)).toList();
  }

  @override
  Future<List<Channel>> loadFavoriteChannels() async {
    final file = File('$favoritesPath/channels.json');
    if (!file.existsSync()) {
      return [];
    }
    String content = await file.readAsString();
    var channels = json.decode(content) as List;
    return channels.map((s) => Channel.fromFile(s)).toList();
  }

  @override
  Future<List<Playlist>> loadFavoritePlaylists() async {
    final file = File('$favoritesPath/playlists.json');
    if (!file.existsSync()) {
      return [];
    }
    String content = await file.readAsString();
    var channels = json.decode(content) as List;
    return channels.map((s) => Playlist.fromFile(s)).toList();
  }

  @override
  Future<List<dynamic>> loadFavoritePodcasts() async {
    // TODO: implement loadFavoriteRadios
    throw UnimplementedError();
  }

  @override
  Future<List<dynamic>> loadFavoriteRadios() async {
    // TODO: implement loadFavoriteRadios
    throw UnimplementedError();
  }

  @override
  Future<void> saveFavoriteSongs(List<Song> songs) async {
    Directory favoritesDir = Directory(favoritesPath);
    if (!favoritesDir.existsSync()) {
      favoritesDir.createSync(recursive: true);
    }
    final file = File('$favoritesPath/songs.json');
    String json = '[${songs.map((e) => e.toFile()).join(',')}]';
    await file.writeAsString(json);
  }

  @override
  Future<void> saveFavoriteChannels(List<Channel> channels) async {
    Directory favoritesDir = Directory(favoritesPath);
    if (!favoritesDir.existsSync()) {
      favoritesDir.createSync(recursive: true);
    }
    final file = File('$favoritesPath/channels.json');
    String json = '[${channels.map((e) => e.toFile()).join(',')}]';
    await file.writeAsString(json);
  }

  @override
  Future<void> saveFavoritePlaylists(List<Playlist> playlists) async {
    Directory favoritesDir = Directory(favoritesPath);
    if (!favoritesDir.existsSync()) {
      favoritesDir.createSync(recursive: true);
    }
    final file = File('$favoritesPath/playlists.json');
    String json = '[${playlists.map((e) => e.toFile()).join(',')}]';
    await file.writeAsString(json);
  }

  @override
  Future<void> saveFavoritePodcasts(List podcasts) {
    // TODO: implement saveFavoritePodcasts
    throw UnimplementedError();
  }

  @override
  Future<void> saveFavoriteRadios(List radios) {
    // TODO: implement saveFavoriteRadios
    throw UnimplementedError();
  }

  @override
  Future<void> addFavoriteChannel(Channel channel) async {
    List<Channel> channels = await loadFavoriteChannels();
    channels.add(channel);
    await saveFavoriteChannels(channels);
  }

  @override
  Future<void> addFavoritePlaylist(Playlist playlist) async {
    List<Playlist> playlists = await loadFavoritePlaylists();
    playlists.add(playlist);
    await saveFavoritePlaylists(playlists);
  }

  @override
  Future<void> addFavoriteSong(Song song) async {
    List<Song> songs = await loadFavoriteSongs();
    songs.add(song);
    await saveFavoriteSongs(songs);
  }

  @override
  Future<void> addSongToCollection(String name, Song song) async {
    List<Song> songs = await loadSongCollection(name);
    songs.add(song);
    await saveSongCollection(name, songs);
  }

  @override
  Future<void> removeFavoriteChannel(String id) async {
    List<Channel> channels = await loadFavoriteChannels();
    if (!channels.any((c) => c.id == id)) {
      return;
    }
    channels.removeWhere((c) => c.id == id);
    await saveFavoriteChannels(channels);
  }

  @override
  Future<void> removeFavoritePlaylist(String id) async {
    List<Playlist> playlists = await loadFavoritePlaylists();
    if (!playlists.any((c) => c.id == id)) {
      return;
    }
    playlists.removeWhere((c) => c.id == id);
    await saveFavoritePlaylists(playlists);
  }

  @override
  Future<void> removeFavoriteSong(String id) async {
    List<Song> songs = await loadFavoriteSongs();
    if (!songs.any((c) => c.id == id)) {
      return;
    }
    songs.removeWhere((c) => c.id == id);
    await saveFavoriteSongs(songs);
  }

  @override
  Future<void> removeSongFromCollection(String name, String id) async {
    List<Song> songs = await loadSongCollection(name);
    if (!songs.any((c) => c.id == id)) {
      return;
    }
    songs.removeWhere((c) => c.id == id);
    await saveSongCollection(name, songs);
  }

  @override
  Future<void> clearFavoriteChannels() async {
    File channels = File('$favoritesPath/channels.json');
    if (channels.existsSync()) {
      await channels.delete();
    }
  }

  @override
  Future<void> clearFavoritePlaylists() async {
    File playlists = File('$favoritesPath/playlists.json');
    if (playlists.existsSync()) {
      await playlists.delete();
    }
  }

  @override
  Future<void> clearFavoriteSongs() async {
    File songs = File('$favoritesPath/songs.json');
    if (songs.existsSync()) {
      await songs.delete();
    }
  }
}
