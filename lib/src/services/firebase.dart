import "package:firebase_core/firebase_core.dart";

import "service.dart";

class FirebaseCore extends Service {
	static final FirebaseCore instance = FirebaseCore();	

	bool isInitialized = false;

	@override
	Future<void> init() async {
		if (!isInitialized) {
			await Firebase.initializeApp();
			isInitialized = true;
		}
	}
}
