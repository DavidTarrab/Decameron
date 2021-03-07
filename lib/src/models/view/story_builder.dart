import "dart:typed_data";

import "package:flutter/foundation.dart";

import "package:decameron/data.dart";
import "package:decameron/models.dart";
import "package:decameron/services.dart";

/// The state of video loading. 
enum VideoState {
	/// Reading the video from the user's device. 
	reading, 

	/// Uploading the video to the cloud. 
	uploading,

	/// Done, video is ready to show. 
	done
}

/// Builds a [Story], one field at a time. 
// ignore: prefer_mixin
class StoryBuilderModel with ChangeNotifier {
	/// The title for this story. 
	String title;

	/// The first catchy sentence of this story. 
	String firstSentence;

	/// The full text and transcription of this story. 
	String text;

	/// The ID for this story. 
	/// 
	/// This will be used as the document ID in the stories collection.
	String id;

	bool didSelectVideo = false;

	/// The state of video loading. 
	VideoState videoState = VideoState.done;

	bool _isLoading = false;
	double _videoProgress;

	/// Creates a view model for uploading stories. 
	StoryBuilderModel() {
		id = Services.instance.database.getRandomStoryId();
	}

	/// The progress of video loading. 
	double get videoProgress => _videoProgress;
	set videoProgress(double value) {
		_videoProgress = value;
		notifyListeners();
	}

	/// Whether the page is loading. 
	bool get isLoading => _isLoading;
	set isLoading(bool value) {
		_isLoading = value;
		notifyListeners();
	}

	/// The story this model represents. 
	Story get story => Story(
		title: title,
		firstSentence: firstSentence,
		author: Models.instance.user.author,
		createdAt: DateTime.now(),
		text: text,
		hasVideo: didSelectVideo,
		id: id,
	);

	/// The URL to download the video. 
	Future<String> get videoUrl => Services.instance.storage.getVideoUrl(id);

	/// Uploads the video to cloud storage. 
	/// 
	/// Updates [videoProgress] along the way. 
	Future<void> uploadVideo(Uint8List bytes) async {
		videoState = VideoState.uploading;
		final Stream<double> videoUploadStream = 
			Services.instance.storage.uploadVideo(bytes, id, Services.instance.auth.uid);
		await for (final double progress in videoUploadStream) {
			videoProgress = progress;
			if (progress == 1) {  // stream does not close by itself
				videoProgress = null;
				break;
			}
		}
		// Firebase seems to have a delay before the video can be retrieved
		await Future.delayed(const Duration(seconds: 1));
	}

	/// Uploads the story to the database. 
	Future<void> upload() => Models.instance.stories.upload(story, id);
}
