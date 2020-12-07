import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerWidget extends StatefulWidget {
  final VideoPlayerController videocontroller;
  final UniqueKey newKey;
  final bool showControls;
  final bool allowFullScreen;
  final double aspectRatio;
  final bool autoplay;
  final bool aInitialize;

  VideoPlayerWidget(
      {this.videocontroller,
      this.newKey,
      this.showControls = true,
      this.allowFullScreen = true,
      this.aspectRatio = 16 / 9,
      this.autoplay = true,
      this.aInitialize = false})
      : super(key: newKey);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  ChewieController _chewieController;

  @override
  void initState() {
    this._initControllers(widget.videocontroller);
    super.initState();
  }

  void _initControllers(VideoPlayerController video) {
    this._chewieController = ChewieController(
        videoPlayerController: widget.videocontroller,
        autoInitialize: widget.aInitialize,
        looping: false,
        showControls: widget.showControls,
        allowFullScreen: widget.allowFullScreen,
        aspectRatio: widget.aspectRatio,
        autoPlay: widget.autoplay,
        deviceOrientationsAfterFullScreen: [
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ],
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
      key: widget.newKey,
      controller: this._chewieController,
    );
  }
}
