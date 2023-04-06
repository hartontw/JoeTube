import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:joetube/models/channel_model.dart';
import 'package:joetube/models/playlist_model.dart';
import 'package:joetube/models/song_model.dart';
import 'package:joetube/services/storage.dart';
import 'package:joetube/services/settings.dart';
import 'package:joetube/services/youtube_api.dart';

Future<void> main() async {
  FileStorage storage = FileStorage('./test/temp');

  test('clear all', () async {
    expect(() async => await storage.deleteDirectory(), returnsNormally);
    expect(() async => await storage.clearFavoriteChannels(), returnsNormally);
    expect(() async => await storage.clearFavoritePlaylists(), returnsNormally);
    expect(() async => await storage.clearFavoriteSongs(), returnsNormally);
    expect(
        () async => await storage.deleteSongCollection('x'), returnsNormally);
    expect(() async => await storage.renameSongCollection('x', 'y'),
        returnsNormally);
  });

  DefaultSettings settings = DefaultSettings();
  InvidiousApi youtubeApi =
      await InvidiousApi.create(settings.getYoutubeApiSettings());

  var random = Random();
  var songsQueries = ['us', 'es', 'ru', 'kr'];
  var channelQueries = ['queen', 'rock', 'classic'];
  var playlistsQueries = ['techno', 'rock', 'pop'];

  var songs = await youtubeApi
      .getTrendingMusic(songsQueries[random.nextInt(songsQueries.length)]);
  var channels = await youtubeApi
      .searchChannel(channelQueries[random.nextInt(channelQueries.length)]);
  var playlists = await youtubeApi.searchPlaylist(
      playlistsQueries[random.nextInt(playlistsQueries.length)]);

  test('song collection', () async {
    expect(() async => await storage.saveSongCollection('trending', songs),
        returnsNormally);

    var loaded = await storage.loadSongCollection('trending');

    expect(loaded, isA<List<Song>>());
    expect(loaded.length, songs.length);

    expect(() async => await storage.saveSongCollection('loaded', loaded),
        returnsNormally);
    expect(() async => await storage.renameSongCollection('loaded', 'renamed'),
        returnsNormally);

    var renamed = await storage.loadSongCollection('renamed');

    expect(renamed, isA<List<Song>>());
    expect(renamed.length, loaded.length);

    var names = await storage.listSongCollections();
    expect(names.length, 2);
    expect(names.first, isIn(['trending', 'renamed']));
    expect(names.last, isIn(['trending', 'renamed']));
    expect(() async => await storage.deleteDirectory(), returnsNormally);
  });

  test('favorite songs', () async {
    expect(() async => await storage.saveFavoriteSongs(songs), returnsNormally);

    var loaded = await storage.loadFavoriteSongs();

    expect(loaded, isA<List<Song>>());
    expect(loaded.length, songs.length);
    expect(() async => await storage.deleteDirectory(), returnsNormally);
  });

  test('favorite channels', () async {
    expect(() async => await storage.saveFavoriteChannels(channels),
        returnsNormally);

    var loaded = await storage.loadFavoriteChannels();

    expect(loaded, isA<List<Channel>>());
    expect(loaded.length, channels.length);
    expect(() async => await storage.deleteDirectory(), returnsNormally);
  });

  test('favorite playlists', () async {
    expect(() async => await storage.saveFavoritePlaylists(playlists),
        returnsNormally);

    var loaded = await storage.loadFavoritePlaylists();

    expect(loaded, isA<List<Playlist>>());
    expect(loaded.length, playlists.length);
    expect(() async => await storage.deleteDirectory(), returnsNormally);
  });
}
