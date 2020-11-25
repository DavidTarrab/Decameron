import "package:firebase_auth/firebase_auth.dart";

import "service.dart";

/// The Authentication service. 
/// 
/// This uses the Firebase Auth service and its plugins. 
class Auth extends Service {
	/// The Firebase provider. 
	final FirebaseAuth firebase = FirebaseAuth.instance;

	/// The Google Sign-in provider.
	final GoogleAuthProvider google = GoogleAuthProvider();

	/// Whether the user is signed in. 
	bool get isSignedIn => firebase.currentUser != null;

	/// The user id for the currently signed in user. 
	String get uid => firebase.currentUser.uid;

	/// The user's account name. 
	String get username => firebase.currentUser.displayName;

	// Only sign in when the user asks to. 
	@override 
	Future<void> init() async {}

	/// Signs the user in using Google Sign-in. 
	Future<void> signIn() => firebase.signInWithPopup(google);

	/// Signs the user out of their account. 
	Future<void> signOut() => firebase.signOut();
}