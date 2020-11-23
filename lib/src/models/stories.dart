import "package:decameron/data.dart";
import "package:decameron/services.dart";

import "model.dart";

class Stories extends Model {
	Iterable<Story> randomStories;

	@override
	Future<void> init() async {
		final Iterable<Map<String, dynamic>> randomJson = 
			await Services.instance.database.getRandomStories(10);

		randomStories = [
			for (final Map<String, dynamic> json in randomJson)
				Story.fromJson(json)
		];
	}
}
