import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class Video_player extends StatefulWidget {
  final VideoPlayerController videocontroller;
  final UniqueKey newKey;

  Video_player({this.videocontroller, this.newKey}) : super(key: newKey);

  @override
  _Video_playerState createState() => _Video_playerState();
}

class _Video_playerState extends State<Video_player> {
  ChewieController _chewieController;

  @override
  void initState() {
    this._initControllers(widget.videocontroller);
    super.initState();
  }

  void _initControllers(VideoPlayerController video) {
    this._chewieController = ChewieController(
        videoPlayerController: widget.videocontroller,
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
    this.widget.videocontroller?.dispose();
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
