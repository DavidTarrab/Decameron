import "package:decameron/data.dart";
import "package:decameron/services.dart";
import "package:decameron/models.dart";

import "model.dart";
import "moderator.dart";

/// A data model for the user profile. 
class User extends Model {
	bool get isSignedIn => Services.instance.auth.isSignedIn;
	bool get isModerator => Models.instance.moderator != null;

	@override 
	Future<void> init() async {
		Services.instance.auth.status
			.listen((value) => authListener(hasData: value));
	}

	Future<void> authListener({bool hasData}) async {
		if (hasData) {
			if (await Services.instance.auth.isModerator) {
				final Moderator moderator = Moderator();
				await moderator.init();
				Models.instance.moderator = moderator;
			}
		} else {
			Models.instance
				..moderator?.dispose()
				..moderator = null;
		}
		notifyListeners();
	}

	/// Gets the user's public profile.
	Author get author {
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
