import "package:decameron/data.dart";
import "package:decameron/services.dart";

import "model.dart";

/// A data model for the user profile. 
class UserModel extends Model {
	/// The user object for the currently signed in user. 
	User user;

	@override 
	Future<void> init() async {
		if (Services.instance.auth.isSignedIn) {
			user = User.fromJson(await Services.instance.database.userProfile);
		} else {
			user = null;
		}
		notifyListeners();  // this function may also be called later
	}
}
