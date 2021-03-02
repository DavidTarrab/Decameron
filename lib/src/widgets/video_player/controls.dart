import "package:flutter/material.dart";
import "package:video_player/video_player.dart" as plugin;

import "controller.dart";
import "player.dart";

extension DurationFormatter on Duration {
  String get timestamp => "${inMinutes.toString().padLeft(2, '0')}:"
    "${(inSeconds % 60).toString().padLeft(2, '0')}";
}

class VideoControls extends StatefulWidget {
  final plugin.VideoPlayerController controller;
  final bool isFullScreen;
  const VideoControls(this.controller, {this.isFullScreen});

  @override
  VideoControlsState createState() => VideoControlsState();
}

class VideoControlsState extends State<VideoControls> {
  plugin.VideoPlayerValue currentValue;

  Duration get bufferedPosition => currentValue.buffered.isEmpty
    ? const Duration(minutes: 0, seconds: 0)
    : currentValue.buffered.last.end;
  Duration get videoLength => currentValue.duration;
  Duration get currentPosition => currentValue.position;
  bool get isPlaying => currentValue.isPlaying;
  bool get hasError => currentValue.hasError;
  bool get isBuffering => currentValue.isBuffering;
  bool get isMuted => currentValue.volume == 0;

  void listener() => setState(() => currentValue = widget.controller.value);

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(listener);
    currentValue = widget.controller.value;
  }

  @override
  void dispose() {
    widget.controller.removeListener(listener);
    super.dispose();
  }

  double durationToDouble(Duration duration) => duration == null ? null 
    : duration.inMinutes * 60.0 + duration.inSeconds;
  Duration doubleToDuration(double position) => 
    Duration(minutes: position ~/ 60, seconds: (position % 60).truncate());

  Future<void> pause() => widget.controller.pause();
  Future<void> play() => widget.controller.play();
  Future<void> seek(Duration duration) => widget.controller.seekTo(duration);

  Future<bool> popWithValue() async {
    final plugin.VideoPlayerValue result = currentValue;
    await pause();
  	Navigator.of(context).pop(result);
  	return false;
  }

  Future<void> toggleFullScreen() async {
    if (widget.isFullScreen) {
    	await popWithValue();
    } else {
    	final plugin.VideoPlayerValue result = await showDialog(
	      context: context,
	      builder: (_) => WillPopScope(
	      	onWillPop: popWithValue, 
	      	child: Scaffold(
		        body: Center(
		        	child: VideoPlayer(
			          VideoController(widget.controller), 
			          isFullScreen: true
			        )
	        	)
        	)
	      )
	    );
      await Future.delayed(const Duration(milliseconds: 250));
	    await widget.controller.initialize();
	    await seek(result.position);
	    if (result.isPlaying) {
        await play();
      }
    }
  }

  @override
  Widget build(BuildContext context) => IconTheme(
    data: const IconThemeData(color: Colors.white),
    child: Container(
      color: Colors.black,
      child: currentValue == null ? null : Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              SliderTheme(
                data: SliderThemeData(thumbShape: SliderComponentShape.noThumb),
                child: Slider(
                  min: 0,
                  max: durationToDouble(videoLength) ?? 1,
                  value: durationToDouble(bufferedPosition),   
                  onChanged: null,         
                )
              ),
              Slider(
                min: 0,
                max: durationToDouble(videoLength) ?? 1,
                value: durationToDouble(currentPosition),
                onChanged: (double value) => seek(doubleToDuration(value))
              ),
            ]
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow ),
                onPressed: isPlaying ? pause : play,
              ),
              IconButton(
                icon: Icon(isMuted ? Icons.volume_off : Icons.volume_up),
                onPressed: () => widget.controller.setVolume(isMuted ? 1 : 0),
              ),
              Text(
              	currentValue == null ? "-- / --" : 
                "${currentPosition.timestamp} / ${videoLength.timestamp}",
                style: Theme.of(context).textTheme.caption
                	.copyWith(color: Colors.white),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                	widget.isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen
              	),
                onPressed: toggleFullScreen,
              )
            ],
          )
        ]
      )
    )
  );
}
