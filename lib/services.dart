import "src/services/auth.dart";
import "src/services/cloud_storage.dart";
import "src/services/file_picker.dart";
import "src/services/firestore.dart";
import "src/services/service.dart";

export "src/services/auth.dart";
export "src/services/cloud_storage.dart";
export "src/services/database.dart";
export "src/services/file_picker.dart";


/// Bundles all the services in one convenient object. 
class Services extends Service {
	/// The singleton instance of this class. 
	static final instance = Services();

	/// The database service. 
	final Database database = Database();

	/// The authentication service. 
	final Auth auth = Auth();

	/// The cloud storage service. 
	final CloudStorage storage = CloudStorage();

	/// The file picker plugin.
	final FilePicker filePicker = FilePicker();

	bool isReady = false;

	@override
	Future<void> init() async {
		await database.init();
		await storage.init();
		isReady = true;
	}
}
