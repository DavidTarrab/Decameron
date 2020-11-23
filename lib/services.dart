import "src/services/firestore.dart";
import "src/services/service.dart";

class Services extends Service {
	static final instance = Services();

	final Database database = CloudFirestore();

	@override
	Future<void> init() async {
		await database.init();
	}
}
