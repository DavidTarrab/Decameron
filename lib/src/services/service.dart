// Dart doesn't like it if we have an abstract class with only one function. 
// They'd rather we pass the function around. But in our case, we want a class
// so we can have an instance to pass around with properties and whatnot. 
// 
// ignore_for_file: one_member_abstracts

/// A service which wraps code we don't own. For example, the database. 
/// 
/// All services must implement [init] to run code when the app starts. 
abstract class Service {
	/// Initializes the service when the app starts. 
	Future<void> init();
}
