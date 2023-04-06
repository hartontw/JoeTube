import 'package:joetube/models/song_model.dart';
import 'package:joetube/models/playlist_model.dart';
import 'package:joetube/models/channel_model.dart';
import 'package:joetube/services/storage.dart';

class MockStorage implements Storage {
  @override
  Future<void> addFavoriteChannel(Channel channel) async {}

  @override
  Future<void> addFavoritePlaylist(Playlist playlist) async {}

  @override
  Future<void> addFavoriteSong(Song song) async {}

  @override
  Future<void> addSongToCollection(String name, Song song) async {}

  @override
  Future<void> clearFavoriteChannels() async {}

  @override
  Future<void> clearFavoritePlaylists() async {}

  @override
  Future<void> clearFavoriteSongs() async {}

  @override
  Future<void> deleteSongCollection(String name) async {}

  @override
  Future<List<String>> listSongCollections() async => [];

  @override
  Future<List<Channel>> loadFavoriteChannels() async => [];

  @override
  Future<List<Playlist>> loadFavoritePlaylists() async => [];

  @override
  Future<List> loadFavoritePodcasts() async => [];

  @override
  Future<List> loadFavoriteRadios() async => [];

  @override
  Future<List<Song>> loadFavoriteSongs() async => [];

  @override
  Future<List<Song>> loadSongCollection(String name) async => [];

  @override
  Future<void> removeFavoriteChannel(String id) async {}

  @override
  Future<void> removeFavoritePlaylist(String id) async {}

  @override
  Future<void> removeFavoriteSong(String id) async {}

  @override
  Future<void> removeSongFromCollection(String name, String id) async {}

  @override
  Future<void> renameSongCollection(String oldName, String newName) async {}

  @override
  Future<void> saveFavoriteChannels(List<Channel> channels) async {}

  @override
  Future<void> saveFavoritePlaylists(List<Playlist> playlists) async {}

  @override
  Future<void> saveFavoritePodcasts(List podcasts) async {}

  @override
  Future<void> saveFavoriteRadios(List radios) async {}

  @override
  Future<void> saveFavoriteSongs(List<Song> songs) async {}

  @override
  Future<void> saveSongCollection(String name, List<Song> collection) async {}
}
