import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/channel_model.dart';
import '../models/playlist_model.dart';
import '../models/song_model.dart';

abstract class YouTubeApi {
  Future<List<Song>> searchSongs(String query, {int page = 1});
  Future<List<Channel>> searchChannel(String query, {int page = 1});
  Future<List<Playlist>> searchPlaylist(String query, {int page = 1});
  Future<Song> getSong(String id);
  Future<Channel> getChannel(String id);
  Future<Playlist> getPlaylist(String id);
  Future<List<Song>> getPlaylistSongs(String id);
  Future<List<Song>> getChannelSongs(String id);
  Future<List<Playlist>> getChannelPlaylists(String id);
  Future<List<Song>> getTrendingMusic(String region);
}

class InvidiousApi implements YouTubeApi {
  InvidiousApi(String url) {
    _url = _validate(url);
  }

  late String _url;
  String get url => _url;
  set url(String api) {
    _url = _validate(api);
  }

  bool _isValid(String url) {
    return Uri.tryParse(url) != null;
  }

  String _validate(String url) {
    if (!_isValid(url)) {
      throw Exception('Invalid YouTube API URL');
    }
    return url;
  }

  @override
  Future<List<Song>> searchSongs(String query, {int page = 1}) async {
    final response = await http.get(Uri.parse(
        '$url/api/v1/search?q=$query&type=video&page=$page&premium=false&liveNow=false&isUpcoming=false'));

    if (response.statusCode != 200) {
      throw Exception('Song search failed');
    }

    var songs = json.decode(utf8.decode(response.bodyBytes)) as List;
    return songs.map((s) => Song.fromJson(s)).toList();
  }

  @override
  Future<List<Channel>> searchChannel(String query, {int page = 1}) async {
    final response = await http
        .get(Uri.parse('$url/api/v1/search?q=$query&type=channel&page=$page'));

    if (response.statusCode != 200) {
      throw Exception('Channel search failed');
    }

    var channels = json.decode(utf8.decode(response.bodyBytes)) as List;
    return channels.map((c) => Channel.fromJson(c)).toList();
  }

  @override
  Future<List<Playlist>> searchPlaylist(String query, {int page = 1}) async {
    final response = await http
        .get(Uri.parse('$url/api/v1/search?q=$query&type=playlist&page=$page'));

    if (response.statusCode != 200) {
      throw Exception('Playlist search failed');
    }

    var playlists = json.decode(utf8.decode(response.bodyBytes)) as List;
    return playlists.map((c) => Playlist.fromJson(c)).toList();
  }

  @override
  Future<Song> getSong(String id) async {
    final response = await http.get(Uri.parse('$url/api/v1/videos/$id'));

    if (response.statusCode != 200) {
      throw Exception('Song get failed');
    }

    return Song.fromJson(json.decode(utf8.decode(response.bodyBytes)));
  }

  @override
  Future<Playlist> getPlaylist(String id) async {
    final response = await http.get(Uri.parse('$url/api/v1/playlists/$id'));

    if (response.statusCode != 200) {
      throw Exception('Playlist get failed');
    }

    return Playlist.fromJson(json.decode(utf8.decode(response.bodyBytes)));
  }

  @override
  Future<Channel> getChannel(String id) async {
    final response = await http.get(Uri.parse('$url/api/v1/channels/$id'));

    if (response.statusCode != 200) {
      throw Exception('Channel get failed');
    }

    return Channel.fromJson(json.decode(utf8.decode(response.bodyBytes)));
  }

  @override
  Future<List<Song>> getPlaylistSongs(String id) async {
    final response = await http.get(Uri.parse('$url/api/v1/playlists/$id/'));

    if (response.statusCode != 200) {
      throw Exception('Playlist songs get failed');
    }

    var songs = json.decode(utf8.decode(response.bodyBytes))['videos'] as List;
    return songs.map((s) => Song.fromJson(s)).toList();
  }

  @override
  Future<List<Song>> getChannelSongs(String id) async {
    final response =
        await http.get(Uri.parse('$url/api/v1/channels/$id/videos/'));

    if (response.statusCode != 200) {
      throw Exception('Channel songs get failed');
    }

    var songs = json.decode(utf8.decode(response.bodyBytes))['videos'] as List;
    return songs.map((s) => Song.fromJson(s)).toList();
  }

  @override
  Future<List<Playlist>> getChannelPlaylists(String id) async {
    final response =
        await http.get(Uri.parse('$url/api/v1/channels/$id/playlists/'));

    if (response.statusCode != 200) {
      throw Exception('Channel playlist get failed');
    }

    var playlists =
        json.decode(utf8.decode(response.bodyBytes))['playlists'] as List;
    return playlists.map((c) => Playlist.fromJson(c)).toList();
  }

  @override
  Future<List<Song>> getTrendingMusic(String region) async {
    final response = await http.get(
        Uri.parse('$url/api/v1/trending?type=Music&region=$region&type=video'));

    if (response.statusCode != 200) {
      throw Exception('Trending get failed');
    }

    var songs = json.decode(utf8.decode(response.bodyBytes)) as List;
    return songs.map((s) => Song.fromJson(s)).toList();
  }
}
