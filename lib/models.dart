import "src/models/data/model.dart";
import "src/models/data/stories.dart";

export "src/models/data/stories.dart";
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

	@override
	Future<void> init() => stories.init();

	@override
	void dispose() {
		stories.dispose();
		super.dispose();
	}
}
