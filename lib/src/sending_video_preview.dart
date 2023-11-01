import 'dart:io';

import 'package:flutter/material.dart';
import './camera_preview_buttons.dart';
import 'package:video_player/video_player.dart';

class SendingVideoViewPage extends StatefulWidget {
  final String path;

  const SendingVideoViewPage({
    super.key,
    required this.path,
  });

  @override
  State<SendingVideoViewPage> createState() => _SendingVideoViewPageState();
}

class _SendingVideoViewPageState extends State<SendingVideoViewPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.path))
      ..initialize().then((value) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Visibility(
              visible: _controller.value.isInitialized,
              child: SizedBox(
                width: double.infinity,
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              ),
            ),
            playPauseButton(),
            const CameraPreviewButtons(),
          ],
        ),
      ),
    );
  }

  Align playPauseButton() {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        onTap: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.black38,
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
