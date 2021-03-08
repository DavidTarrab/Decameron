import "service.dart";

/// Provides access to the database. 
/// 
/// Leave the actual implementation to a subclass. Use this class to cleanly 
/// define what should be accessible from the database. 
abstract class Database extends Service {
	/// Gets n random stories from the database. 
	Future<List<Map>> getRandomStories(int n);

	/// Uploads a story to the database. 
	Future<void> uploadStory(Map json, String id);

	/// The user profile. 
	Future<Map> get userProfile;

	/// Creates or updates the user profile. 
	Future<void> setProfile(Map json);

	Future<List<Map>> get pendingStories;

	Future<void> approveStory(String id);

	Future<void> deleteStory(String id);

	Future<void> uploadStoryToUser(String id);

	/// Gets a random ID for a new story.
	/// 
	/// Nothing actually happens with this ID until the story is uploaded 
	/// using [uploadStory].  
	String getRandomStoryId();
}