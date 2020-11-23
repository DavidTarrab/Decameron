import "service.dart";

/// Provides access to the database. 
/// 
/// Leave the actual implementation to a subclass. Use this class to cleanly 
/// define what should be accessible from the database. 
abstract class Database extends Service {
	/// Gets n random stories from the database. 
	Future<List<Map>> getRandomStories(int n);
}