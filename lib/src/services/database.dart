import "service.dart";

abstract class Database extends Service {
	Future<List<Map<String, dynamic>>> getRandomStories(int n);
}