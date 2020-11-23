import "src/models/model.dart";
import "src/models/stories.dart";

export "src/models/stories.dart";

class Models extends Model {
	static Models instance = Models();

	final Stories stories = Stories();

	@override
	Future<void> init() => stories.init();

	@override
	void dispose() {
		stories.dispose();
		super.dispose();
	}
}
