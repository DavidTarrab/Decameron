import "package:decameron/data.dart";
import "package:decameron/models.dart";

/// Builds a [Story], one field at a time. 
class StoryBuilderModel {
	/// The title for this story. 
	String title;

	/// The first catchy sentence of this story. 
	String firstSentence;

	/// The full text and transcription of this story. 
	String text;

	/// The story this model represents. 
	Story get story => Story(
		title: title,
		firstSentence: firstSentence,
		author: Models.instance.user.author,
		createdAt: DateTime.now(),
		text: text,
	);
}