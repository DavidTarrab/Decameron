import "package:meta/meta.dart";

/// A user profile. 
/// 
/// This contains a list of every story the user has told. 
class User {
	/// A list of IDs, one for each story this user told. 
	final List<String> stories;

	/// Creates a new user profile. 
	const User({
		@required this.stories,
	});

	/// Loads a user profile from JSON. 
	User.fromJson(Map json) : 
		stories = List<String>.from(json ["stories"]);

	/// The JSON representation of this user. 
	Map get json => {
		"stories": stories,
	};
}
