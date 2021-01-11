import "dart:typed_data";

import "package:firebase_storage/firebase_storage.dart";

import "firebase.dart";
import "service.dart";

/// A wrapper around Firebase Cloud Storage. 
class CloudStorage implements Service {
	/// The Firebase Storage instance. 
	static final FirebaseStorage firebase = FirebaseStorage.instance;

	/// The reference to videos for stories. 
	final Reference storyVideos = firebase.ref("stories/videos");

	@override
	Future<void> init() async {
		await FirebaseCore.instance.init();
	}

	/// Uploads a video to Firebase.
	/// 
	/// Videos are associated with IDs, the same as the document ID for the 
	/// corresponding story. 
	Stream<double> uploadVideo(Uint8List data, String id) => 
		storyVideos.child(id).putData(data).snapshotEvents.map(
			(TaskSnapshot snapshot) => snapshot.bytesTransferred / snapshot.totalBytes
		);

	/// Gets the URL for a video with the given ID. 
	Future<String> getVideoUrl(String id) => 
		storyVideos.child(id).getDownloadURL();
}
