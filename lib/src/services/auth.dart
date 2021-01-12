import "package:firebase_auth/firebase_auth.dart";

import "service.dart";

/// The Authentication service. 
/// 
/// This uses the Firebase Auth service and its plugins. 
class Auth extends Service {
	/// The Firebase provider. 
	static final FirebaseAuth firebase = FirebaseAuth.instance;

	/// The Google Sign-in provider.
	final GoogleAuthProvider google = GoogleAuthProvider();

	/// Whether the user is signed in. 
	bool get isSignedIn => firebase.currentUser != null;

	/// The user id for the currently signed in user. 
	String get uid => firebase.currentUser.uid;

	/// The user's account name. 
	String get username => firebase.currentUser.displayName;

	/// Whether the user has permissions to moderate the site. 
	Future<bool> get isModerator async {
		final IdTokenResult token = await firebase.currentUser.getIdTokenResult();
		return token.claims ["isModerator"] ?? false;
	}

	/// Passes along changes in the authentication state.
	/// 
	/// The type is void since other fields in this class should be used
	/// instead of the [User] object passed in the original stream. 
	Stream<bool> status = firebase.userChanges().map(
		(User user) => user != null
	);

	// Only sign in when the user asks to. 
	@override 
	Future<void> init() async {}

	/// Signs the user in using Google Sign-in. 
	Future<void> signIn() => firebase.signInWithPopup(google);

	/// Signs the user out of their account. 
	Future<void> signOut() => firebase.signOut();
}