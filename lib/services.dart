import "src/services/auth.dart";
import "src/services/firestore.dart";
import "src/services/service.dart";

export "src/services/database.dart";

/// Bundles all the services in one convenient object. 
class Services extends Service {
	/// The singleton instance of this class. 
	static final instance = Services();

	/// The database service. 
	final Database database = CloudFirestore();

	/// The authentication service. 
	final Auth auth = Auth();

	@override
	Future<void> init() async {
		await database.init();
	}
}
