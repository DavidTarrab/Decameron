class Story {
	final DateTime createdAt;
	final String authorID;
	final String title;
	final String firstSentence;
	final String text;

	Story.fromJson(Map<String, dynamic> json) : 
		createdAt = DateTime.parse(json ["createdAt"]),
		authorID = json ["authorID"],
		title = json ["title"],
		firstSentence = json ["firstSentence"],
		text = json ["text"];
}
