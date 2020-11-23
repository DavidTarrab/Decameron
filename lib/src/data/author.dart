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

	/// Reads an author from a JSON object. 
	Author.fromJson(Map json) : 
		first = json ["first"],
		last = json ["last"],
		uid = json ["uid"];
}
