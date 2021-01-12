import "package:meta/meta.dart";

import "author.dart";

/// A story told by the fireplace. 
class Story {
	/// The date and time when this story was told. 
	final DateTime createdAt;

	/// The storyteller. 
	final Author author;

	/// The title of this story. 
	final String title;

	/// The first sentence of this story.
	/// 
	/// This does not necessarily have to be the first sentence spoken. Instead 
	/// it should be a catchy one-liner to hook the audience. 
	final String firstSentence;

	/// The full transcript of the story. 
	final String text;

	/// Whether this story has been approved by a site moderator. 
	final bool isApproved;

	/// The ID of this story in the database. 
	final String id;

	/// Creates a story. 
	Story({
		@required this.createdAt,
		@required this.author,
		@required this.title,
		@required this.firstSentence,
		@required this.text,
		@required this.id,
		this.isApproved = false,
	});

	/// Reads a story from a JSON object. 
	Story.fromJson(Map json) : 
		createdAt = DateTime.parse(json ["createdAt"]),
		author = Author.fromJson(json ["author"]),
		title = json ["title"],
		firstSentence = json ["firstSentence"],
		text = json ["text"],
		id = json ["id"],
		isApproved = json ["isApproved"];

	/// The JSON representation of this object. 
	Map get json => {
		"createdAt": createdAt.toString(),
		"author": author.json,
		"title": title,
		"firstSentence": firstSentence,
		"text": text,
		"isApproved": isApproved,
		"id": id,
	};
}
