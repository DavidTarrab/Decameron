import "package:decameron/data.dart";

/// Builds a [Story], one field at a time. 
class StoryBuilderModel {
	/// The title for this story. 
	String title;

	/// The first and last names of the author. 
	String firstName, lastInitial;

	/// The first catchy sentence of this story. 
	String firstSentence;

	/// The full text and transcription of this story. 
	String text;

	/// The author's user id. 
	String uid;

	/// The story this model represents. 
	Story get story => Story(
		title: title,
		firstSentence: firstSentence,
		author: Author(
			first: firstName,
			last: lastInitial,
			uid: uid,
		),
		createdAt: DateTime.now(),
		text: text,
	);
}