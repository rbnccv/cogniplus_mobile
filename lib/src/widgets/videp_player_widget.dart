import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlayer extends StatefulWidget {
  final String videoUrl;
  final UniqueKey newKey;

  VideoPlayer(this.videoUrl, this.newKey) : super(key: newKey);

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  @override
  void initState() {
    this._initControllers(this.widget.videoUrl);
    super.initState();
  }

  void _initControllers(String url) {
    this._videoPlayerController = VideoPlayerController.network(url);
    this._chewieController = ChewieController(
        videoPlayerController: this._videoPlayerController,
        autoInitialize: true,
        looping: false,
        showControls: true,
        autoPlay: true,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: TextStyle(color: Colors.white),
            ),
          );
        });
  }

  @override
  void dispose() {
    this._videoPlayerController?.dispose();
    this._chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(
      controller: this._chewieController,
    );
  }
}
