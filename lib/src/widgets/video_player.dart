import "package:flutter/material.dart";
import "package:chewie/chewie.dart";
import "package:video_player/video_player.dart" show VideoPlayerController;

class VideoPlayer extends StatefulWidget {
	static const double aspectRatio = 1.5;

	final Future<String> urlFuture;
	const VideoPlayer(this.urlFuture);

	@override
	VideoPlayerState createState() => VideoPlayerState();
}

class VideoPlayerState extends State<VideoPlayer> {
	ChewieController controller;
	Future<String> urlFuture;

	bool get hasVideo => urlFuture != null;
	bool get isReady => hasVideo && controller != null;

	@override
	void initState() {
		super.initState();
		urlFuture = widget.urlFuture;
		getController();
	}

	@override
	void didUpdateWidget(VideoPlayer oldWidget) {
		super.didUpdateWidget(oldWidget);
		urlFuture = widget.urlFuture;
		getController();
	}

	Future<void> getController() async {
		if (urlFuture == null) {
			return;
		}
		final String url = await urlFuture;
		final VideoPlayerController videoController = 
			VideoPlayerController.network(url);
		await videoController.initialize();
		setState(() => 
			controller = ChewieController(videoPlayerController: videoController)
		);
	}

	@override
	Widget build(BuildContext context) => AspectRatio(
		aspectRatio: VideoPlayer.aspectRatio,
		child: isReady ? Chewie(controller: controller)
			: Stack(
				children: [
					Container(color: Colors.grey [200].withOpacity(0.1)), 
					if (hasVideo) const Align(
						alignment: Alignment.bottomCenter, 
						child: LinearProgressIndicator()
					)
				]
			)
	);
}
