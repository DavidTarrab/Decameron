import "package:decameron/data.dart";
import "package:decameron/services.dart";

import "model.dart";

class Moderator extends Model {
	@override
	Future<void> init() async { }

	Future<void> approveStory(Story story) async {
		await Services.instance.database.approveStory(story.id);
		notifyListeners();
	}

	Future<void> deleteStory(Story story) async {
		await Services.instance.database.deleteStory(story.id);
		notifyListeners();
	}

	Future<List<Story>> get pendingStories async => [
		for (final Map json in await Services.instance.database.pendingStories)
			Story.fromJson(json)
	];
}