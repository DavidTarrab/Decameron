import "package:flutter/material.dart";
import "package:video_player/video_player.dart" as plugin;

import "controller.dart";
import "controls.dart";

class VideoPlayer extends StatefulWidget {
  final bool isFullScreen;
  final VideoController controller;

  const VideoPlayer(
    this.controller,
    {this.isFullScreen = false}
  );

  @override
  VideoPlayerState createState() => VideoPlayerState();
}

class VideoPlayerState extends State<VideoPlayer> {
	plugin.VideoPlayerController controller;

	bool get hasController => controller != null;
	bool get isControllerReady => controller?.value?.initialized ?? false;
	bool get isReady => hasController && isControllerReady;

	void listener() => setState(
		() => controller = widget.controller.pluginController
	);

	@override
	void initState() {
		super.initState();
		widget.controller.addListener(listener);
		controller = widget.controller.pluginController;
	}

  @override
  void dispose() {
  	widget.controller.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Hero(
    tag: "video-player",
    child: AspectRatio(
	  	aspectRatio: 1.5,
	  	child: isReady
		  	? Column(
		  		children: [
		  			Expanded(child: plugin.VideoPlayer(controller)), 
		  			SizedBox(
	  			    height: 100, 
	  			    child: VideoControls(
	  			    	controller, 
	  			    	isFullScreen: widget.isFullScreen,
	  			  	)
	  			  ),
		  		],
	  		)
	  		: Stack(
		  		children: [
		  			Container(color: Colors.grey [200].withOpacity(0.1)),
		  			if (hasController) const Align(  // video is just loading
							alignment: Alignment.bottomCenter, 
							child: LinearProgressIndicator()
						)
					]
  			)
		)
	);
}
