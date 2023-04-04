import 'package:joetube/models/channel_model.dart';
import 'package:joetube/models/playlist_model.dart';
import 'package:joetube/models/song_model.dart';
import 'package:joetube/models/thumbnails_model.dart';
import 'package:joetube/services/youtube_api.dart';

class MockYouTubeApi implements YouTubeApi {
  List<Song> songs = [
    Song(
      id: '1',
      title: 'Song 1',
      author: 'Channel 1',
      authorId: '1',
      thumbnails: Thumbnails(
        low: 'https://via.placeholder.com/150',
        medium: 'https://via.placeholder.com/300',
        high: 'https://via.placeholder.com/600',
      ),
      duration: const Duration(seconds: 60),
    ),
    Song(
      id: '2',
      title: 'Song 2',
      author: 'Channel 1',
      authorId: '1',
      thumbnails: Thumbnails(
        low: 'https://via.placeholder.com/150',
        medium: 'https://via.placeholder.com/300',
        high: 'https://via.placeholder.com/600',
      ),
      duration: const Duration(seconds: 60),
    ),
  ];

  List<Channel> channels = [
    Channel(
      id: '1',
      name: 'Channel 1',
      description: 'Channel 1 Description',
      thumbnails: Thumbnails(
        low: 'https://via.placeholder.com/150',
        medium: 'https://via.placeholder.com/300',
        high: 'https://via.placeholder.com/600',
      ),
      verified: false,
    ),
    Channel(
      id: '2',
      name: 'Channel 2',
      description: 'Channel 2 Description',
      thumbnails: Thumbnails(
        low: 'https://via.placeholder.com/150',
        medium: 'https://via.placeholder.com/300',
        high: 'https://via.placeholder.com/600',
      ),
      verified: false,
    ),
  ];

  List<Playlist> playlists = [
    Playlist(
      id: '1',
      title: 'Playlist 1',
      thumbnail: 'https://via.placeholder.com/150',
      author: 'Channel 1',
      authorId: '1',
      songCount: 10,
    ),
    Playlist(
      id: '2',
      title: 'Playlist 2',
      thumbnail: 'https://via.placeholder.com/150',
      author: 'Channel 1',
      authorId: '1',
      songCount: 12,
    ),
  ];

  @override
  Future<List<Song>> searchSongs(String query, {int page = 1}) async {
    return songs;
  }

  @override
  Future<List<Channel>> searchChannel(String query, {int page = 1}) async {
    return channels;
  }

  @override
  Future<List<Playlist>> searchPlaylist(String query, {int page = 1}) async {
    return playlists;
  }

  @override
  Future<Song> getSong(String id) async {
    return songs.firstWhere((s) => s.id == id);
  }

  @override
  Future<Playlist> getPlaylist(String id) async {
    return playlists.firstWhere((p) => p.id == id);
  }

  @override
  Future<Channel> getChannel(String id) async {
    return channels.firstWhere((c) => c.id == id);
  }

  @override
  Future<List<Song>> getPlaylistSongs(String id) async {
    return songs;
  }

  @override
  Future<List<Song>> getChannelSongs(String id) async {
    return songs.where((s) => s.authorId == id).toList();
  }

  @override
  Future<List<Playlist>> getChannelPlaylists(String id) async {
    return playlists.where((s) => s.authorId == id).toList();
  }

  @override
  Future<List<Song>> getTrendingMusic(String region) async {
    return songs;
  }
}
