import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'package:joetube/services/audio_service.dart';
import 'package:joetube/services/settings.dart';
import 'package:joetube/services/youtube_api.dart';

import 'screens/screens.dart';

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  //PodcastService
  //RadioService

  UserSettings settings = UserSettings();
  await settings.init();

  AudioService audioService = AudioService(settings.getMaxSongHistory());
  settings.addMaxSongHistoryListener((max) => audioService.maxHistory = max);

  InvidiousApi youtubeApi = InvidiousApi(settings.getYoutubeApiUrl());
  settings.addYoutubeApiUrlListener((url) => youtubeApi.url = url);

  runApp(JoeTube(
    settings: settings,
    audio: audioService,
    youtube: youtubeApi,
  ));
}

class JoeTube extends StatefulWidget {
  const JoeTube(
      {super.key,
      required this.settings,
      required this.audio,
      required this.youtube});

  final Settings settings;
  final AudioService audio;
  final YouTubeApi youtube;

  @override
  State<JoeTube> createState() => _JoeTubeState();
}

class _JoeTubeState extends State<JoeTube> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'JoeTube',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.white,
                displayColor: Colors.white,
              )),
      home: const HomeScreen(),
      getPages: [
        GetPage(name: '/', page: () => const HomeScreen()),
        GetPage(name: '/songlist', page: () => const SonglistScreen()),
      ],
    );
  }
}
