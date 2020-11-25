import "package:decameron/data.dart";
import "package:decameron/services.dart";

import "model.dart";

/// A data model for the user profile. 
class UserModel extends Model {
	/// The user object for the currently signed in user. 
	User user;

	/// The personally identifying information about this user. 
	Author author;

	/// Whether the user is signed in.
	/// 
	/// Sign-in is optional, and only required for uploading stories.
	bool get isSignedIn => Services.instance.auth.isSignedIn;

	@override 
	Future<void> init() async {
		final Services services = Services.instance;
		if (isSignedIn) {
			user = User.fromJson(await services.database.userProfile);
			final String uid = services.auth.uid;
			final String name = services.auth.username;
			final List<String> parts = name.split(" ");
			final String firstName = parts [0];
			final String lastInitial = parts [1] [0];
			author = Author(
				first: firstName,
				last: lastInitial,
				uid: uid,
			);
		} else {
			user = null;
			author = null;
		}
		notifyListeners();  // this function may also be called later
	}

	/// Signs the user in. 
	Future<void> signIn() async {
		await Services.instance.auth.signIn();
		await init();
	}

	/// Signs the user out. 
	Future<void> signOut() async {
		await Services.instance.auth.signOut(); 
		await init();
	}
}
