class Author {
	final String first;
	final String last;
	final String uid;

	Author.fromJson(Map<String, dynamic> json) : 
		first = json ["first"],
		last = json ["last"],
		uid = json ["uid"];
}
