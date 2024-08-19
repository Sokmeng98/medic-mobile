import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayer extends StatelessWidget {
  const VideoPlayer({super.key, required this.url});
  final url;

  @override
  Widget build(BuildContext context) {
    return (YoutubePlayer(
      controller: YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(url) ?? '',
        flags: YoutubePlayerFlags(hideThumbnail: true, hideControls: true, autoPlay: false),
      ),
    ));
  }
}
