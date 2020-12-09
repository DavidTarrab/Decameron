import "package:meta/meta.dart";

/// A storyteller. 
/// 
/// Since students are under 18, we can only use their last initial. 
class Author {
	/// The storyteller's first name. 
	final String first;

	/// The storyteller's last name. 
	/// 
	/// Since minors are involved, we can only use their last initial. 
	final String last;

	/// The author's user ID. 
	final String uid;

	/// Defines a storyteller. 
	Author({
		@required this.first,
		@required this.last,
		@required this.uid,
	});

	/// Reads an author from a JSON object. 
	Author.fromJson(Map json) : 
		first = json ["first"],
		last = json ["last"],
		uid = json ["uid"];

	/// The JSON representation of this object. 
	Map get json => {
		"first": first,
		"last": last,
		"uid": uid,
	};
}
