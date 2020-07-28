import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ChewieListItem extends StatefulWidget {
  // This will contain the URL/asset path which we want to play
  final VideoPlayerController videoPlayerController;
  final bool looping;

  ChewieListItem({
    @required this.videoPlayerController,
    this.looping,
    Key key,
  }) : super(key: key);

  @override
  _ChewieListItemState createState() => _ChewieListItemState();
}

class _ChewieListItemState extends State<ChewieListItem> {
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      aspectRatio: 16 / 9,
      autoInitialize: true,
      looping: widget.looping,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ),
        );
      },
      /*
      customControls: Stack(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.play_circle_filled,
                color: Color(0xff67CABA), size: 48),
            onPressed: () {
              if (!widget.videoPlayerController.value.isPlaying)
                _chewieController.play();
              else
                _chewieController.pause();
            },
          )
        ],
      ),*/
      showControls: true,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.blueGrey,
        handleColor: Color(0xff67CABA),
        backgroundColor: Colors.green,
        bufferedColor: Colors.greenAccent,
      ),
      placeholder: Container(
        color: Colors.transparent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(
      controller: _chewieController,
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
  }
}
