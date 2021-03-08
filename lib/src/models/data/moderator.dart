import "package:decameron/data.dart";
import "package:decameron/services.dart";

import "model.dart";

class Moderator extends Model {
	List<Story> pendingStories;

	@override
	Future<void> init() async {
		pendingStories = await getPendingStories();
	}

	Future<void> approveStory(Story story) async {
		await Services.instance.database.approveStory(story.id);
		await init();
		notifyListeners();
	}

	Future<List<Story>> getPendingStories() async => [
		for (final Map json in await Services.instance.database.pendingStories)
			Story.fromJson(json)
	];
}