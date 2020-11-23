import "package:decameron/data.dart";
import "package:decameron/services.dart";

import "model.dart";

/// The data models for the stories. 
/// 
/// All logic pertaining to getting and setting stories happens here. 
class Stories extends Model {
	/// The first twenty random stories.
	List<Story> randomStories;

	@override
	Future<void> init() async {
		final Iterable<Map> randomJson = 
			await Services.instance.database.getRandomStories(10);

		randomStories = [
			for (final Map<String, dynamic> json in randomJson)
				Story.fromJson(json)
		];
	}
}
