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
		if (isSignedIn) {
			user = await getUserProfile();
			author = getAuthor();
		} else {
			user = null;
			author = null;
		}
		notifyListeners();  // this function may also be called later
	}

	/// Gets the user profile, creating one if necessary.
	Future<User> getUserProfile() async {
		final Database database = Services.instance.database;
		final Map json = await database.userProfile;
		User result;
		if (json == null) {
			result = const User(stories: []);
			await database.setProfile(result.json);
		} else {
			result = User.fromJson(json);
		}
		return result;
	}

	/// Gets the user's public profile.
	Author getAuthor() {
		final Auth auth = Services.instance.auth;
		final String uid = auth.uid;
		final String name = auth.username;
		final List<String> parts = name.split(" ");
		final String firstName = parts [0];
		final String lastInitial = parts [1] [0];
		return Author(
			first: firstName,
			last: lastInitial,
			uid: uid,
		);
	}

	/// Signs the user in. 
	Future<void> signIn() async {
		try {
			await Services.instance.auth.signIn();
			await init();
		} catch (error) {
			await signOut();  // this way the next reload won't error
			rethrow;  // hand it over to the UI
		}
	}

	/// Signs the user out. 
	Future<void> signOut() async {
		await Services.instance.auth.signOut(); 
		await init();
	}
}
