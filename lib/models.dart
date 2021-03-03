// Imports
import "src/models/data/model.dart";
import "src/models/data/moderator.dart";
import "src/models/data/stories.dart";
import "src/models/data/user.dart";

// Exports -- data models
export "src/models/data/moderator.dart";
export "src/models/data/stories.dart";
export "src/models/data/user.dart";

// Exports -- view models
export "src/models/view/story_builder.dart";

/// Bundles all the data models in one convenient model. 
/// 
/// Instead of managing each individual model, simply call [init] and [dispose] 
/// on this instance, which will manage the lifecycle of other models. 
class Models extends Model {
	/// The singleton instance of this class. 
	static Models instance = Models();

	/// The stories data model. 
	final Stories stories = Stories();

	/// The user data model.
	final UserModel user = UserModel();

	bool isReady = false;

	Moderator moderator;

	@override
	Future<void> init() async {
		await user.init();
		await stories.init();
		isReady = true;
	}

	@override
	void dispose() {
		stories.dispose();
		user.dispose();
		super.dispose();
	}
}
