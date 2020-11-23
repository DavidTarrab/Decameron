import "package:firebase_core/firebase_core.dart";

import "service.dart";

/// Initializes Firebase Core, which is needed by all Firebase products. 
/// 
/// Firebase Core can only be initialized once, so this class ensures that it 
/// does not happen more than once. Use `FirebaseCore.instance.init()`.
class FirebaseCore extends Service {
	/// The singleton for this object. 
	static final FirebaseCore instance = FirebaseCore();	

	/// Whether Firebase has already been initialized. 
	bool isInitialized = false;

	@override
	Future<void> init() async {
		if (!isInitialized) {
			await Firebase.initializeApp();
			isInitialized = true;
		}
	}
}
