import "package:flutter/foundation.dart" show ChangeNotifier;
import "package:video_player/video_player.dart" as plugin;

// ignore: prefer_mixin
class VideoController with ChangeNotifier {
	plugin.VideoPlayerController pluginController;
	VideoController([this.pluginController]) {
		pluginController?.addListener(notifyListeners);
	}

	Future<void> initialize([String url]) async {
		if (pluginController == null && url == null) {
			throw ArgumentError("URL must be non-null");
		}
		pluginController = plugin.VideoPlayerController.network(url)
			..addListener(notifyListeners);
		notifyListeners();  // allow widget to show loading indicator
		await pluginController.initialize();
		notifyListeners();  // allow widget to show video
	}

	@override
	void dispose() {
		pluginController
			..removeListener(notifyListeners)
			..dispose();
		super.dispose();
	}
}
