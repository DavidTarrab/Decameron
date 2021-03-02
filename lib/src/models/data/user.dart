import "package:decameron/data.dart";
import "package:decameron/services.dart";
import "package:decameron/models.dart";

import "model.dart";
import "moderator.dart";

/// A data model for the user profile. 
class UserModel extends Model {
	/// The user object for the currently signed in user. 
	User user;

	/// The personally identifying information about this user. 
	Author author;

	/// Whether the user is signed in.
	/// 
	/// Sign-in is optional, and only required for uploading stories.
	bool get hasData => user != null;

	bool get isModerator => Models.instance.moderator != null;

	@override 
	Future<void> init([bool isSignedIn]) async {
		if (isSignedIn == null) {
			Services.instance.auth.status.listen(init);
		} else if (isSignedIn) {
			user = await getUserProfile();
			author = getAuthor();
			if (await Services.instance.auth.isModerator) {
				final Moderator moderator = Moderator();
				await moderator.init();
				Models.instance.moderator = moderator;
			}
		} else {
			user = null;
			author = null;
			Models.instance.moderator = null;
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
		} catch (error) {
			await signOut();  // this way the next reload won't error
			rethrow;  // hand it over to the UI
		}
	}

	/// Signs the user out. 
	Future<void> signOut() async {
		await Services.instance.auth.signOut(); 
	}
}
