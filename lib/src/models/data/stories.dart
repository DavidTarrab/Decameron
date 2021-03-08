import "package:decameron/data.dart";
import "package:decameron/services.dart";

import "model.dart";

List<Story> storiesFromList(List<Map> list) => [
	for (final Map json in list)
		Story.fromJson(json)
];

/// The data models for the stories. 
/// 
/// All logic pertaining to getting and setting stories happens here. 
class Stories extends Model {
	/// The first twenty random stories.
	List<Story> randomStories;

	/// Downloads random stories from the database. 
	/// 
	/// See [Database.getRandomStories].
	Future<List<Story>> getRandomStories() async => storiesFromList(
		await Services.instance.database.getRandomStories(10)
	);

	@override
	Future<void> init() async {
		randomStories = await getRandomStories();
	}

	/// Uploads a story to the database. 
	/// 
	/// Also updates the random list of stories.
	Future<void> upload(Story story, String id) async { 
		await Services.instance.database.uploadStory(story.json, id);
		notifyListeners();  // updates the fireplace with the new story
	}

	/// Returns the download URL of this story's video. 
	Future<String> getVideoUrl(Story story) => 
		Services.instance.storage.getVideoUrl(story.id);

	Future<void> deleteStory(Story story) async {
		await Services.instance.database.deleteStory(story.id);
		randomStories.remove(story);
		notifyListeners();
	}

	Future<List<Story>> getStoriesByAuthor(Author author) async => storiesFromList(
		await Services.instance.database.getStoriesByAuthor(author.uid)
	);
}
