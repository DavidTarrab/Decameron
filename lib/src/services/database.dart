import "service.dart";

abstract class Database extends Service {
	Future<Iterable<Map<String, dynamic>>> getRandomStories(int n);
}