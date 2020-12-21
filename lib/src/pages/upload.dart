import "dart:typed_data";

import "package:flutter/material.dart";
import "package:video_player/video_player.dart";
import "package:chewie/chewie.dart";

import "package:decameron/models.dart";
import "package:decameron/widgets.dart";
import "package:decameron/services.dart";

/// A page to create and upload a new story. 
class StoryUploaderPage extends StatefulWidget {
	@override
	StoryUploaderState createState() => StoryUploaderState();
}

/// A state to manage all the individual fields of [StoryUploaderPage]. 
class StoryUploaderState extends State<StoryUploaderPage> {
	/// The model that builds the story field by field. 
	final StoryBuilderModel model = StoryBuilderModel();

	/// The video controller. 
	VideoPlayerController videoController;

	/// The UI controller for the video. 
	ChewieController chewieController;

	@override
	void initState() {
		super.initState();
		model.addListener(listener);
	}

	@override
	void dispose() {
		model.removeListener(listener);
		super.dispose();
	}

	/// Updates the UI when the underlying data changes. 
	void listener() => setState(() {});

	@override
	Widget build(BuildContext context) => Scaffold(
		appBar: AppBar(title: const Text("Tell a story")),
		floatingActionButton: !model.isLoading ? null : FloatingActionButton(
			onPressed: null,
			child: CircularProgressIndicator(
				valueColor: AlwaysStoppedAnimation(  // has to be an animation
					Theme.of(context).colorScheme.onSecondary
				)
			),
		),
		body: Form(
			child: Center(child: 
				ConstrainedBox(
					constraints: const BoxConstraints(maxWidth: 750),
					child: ListView(
						padding: const EdgeInsets.all(10),
						children: [
							const SizedBox(height: 10),
							FractionallySizedBox( 
								widthFactor: 2/3,
								child: TextFormField(
									onSaved: (String value) => model.title = value,
									textAlign: TextAlign.center, 
									decoration: const InputDecoration(
										hintText: "Your amazing story",
										border: OutlineInputBorder(),
									),
								)
							),
							const SizedBox(height: 20),
							AspectRatio(
								aspectRatio: 1.5,
								child: videoController == null 
									? const Placeholder() 
									: Chewie(controller: chewieController),
							),
							if (model.videoState != VideoState.done) ...[
								LinearProgressIndicator(value: model.videoProgress),
								if (model.videoState == VideoState.reading)
									const Text("Reading video")
								else if (model.videoState == VideoState.uploading)
									const Text("Uploading video")
								else if (model.videoState == VideoState.displaying)
									const Text("Displaying video")
							],
							const SizedBox(height: 10),
							Row(
								mainAxisAlignment: MainAxisAlignment.spaceBetween,
								children: [
									const Text("Upload a video"),
									OutlinedButton(
										child: const Text("Select file"),
										onPressed: chooseVideo,
									)
								]
							),
							const SizedBox(height: 30),
							FormRow(
								label: "Catchy first sentence",
								onSaved: (String value) => model.firstSentence = value,
							),
							const SizedBox(height: 20),
							const Text("Type out the full story here"),
							const SizedBox(height: 10),
							TextFormField(
								onSaved: (String value) => model.text = value,
								maxLines: null,
								decoration: const InputDecoration(
									filled: true,
									border: OutlineInputBorder()
								),
							),
							const SizedBox(height: 20),
							Builder(
								builder: (BuildContext context) => SizedBox(
									width: 100, child: RaisedButton(
										onPressed: () => upload(context),
										child: const Text("Upload"),
									)
								)
							)
						]
					)
				)
			)
		)
	);

	/// Selects a video from the user's device. 
	Future<void> chooseVideo() async {
		// 1. Let user pick a video from their device. 
		final FilePicker picker = Services.instance.filePicker;
		final FileOnDevice file = await picker.pickVideo();
		if (file == null) {
			return;
		}

		// 2. Read the file from the device. 
		model.videoState = VideoState.reading;
		final Uint8List bytes = await picker.readFile(
			file,
			progressCallback: (double progress) => model.videoProgress = progress,
		);

		// 3. Upload the video to the cloud.
		await model.uploadVideo(bytes);

		// 4. Display the video in the UI. 
		model.videoState = VideoState.displaying;
		// Firebase Storage seems to need time to process it. 
		await Future.delayed(const Duration(seconds: 1));
		videoController = VideoPlayerController.network(await model.videoUrl);
		await videoController.initialize();
		chewieController = ChewieController(videoPlayerController: videoController);
		model.videoState = VideoState.done;
		setState(() {});
	}

	/// Uploads the story inputted by the user. 
	Future<void> upload(BuildContext context) async {
		model.isLoading = true;
		try {
			if (!Form.of(context).validate()) {
				model.isLoading = false;
				return;
			}
			Form.of(context).save();
			await model.upload();
		} catch (error) {  // ignore: avoid_catches_without_on_clauses
			Scaffold.of(context).showSnackBar(
				SnackBar(
					content: const Text("Error while uploading story"),
					action: SnackBarAction(
						label: "RETRY",
						onPressed: () => upload(context),
					)
				)
			);
			model.isLoading = false;
			rethrow;
		}
		model.isLoading = false;
		Navigator.of(context).pop();
	}
}
