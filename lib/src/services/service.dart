// Dart doesn't like it if we have an abstract class with only one function. 
// They'd rather we pass the function around. But in our case, we want a class
// so we can have an instance to pass around with properties and whatnot. 
// 
// ignore_for_file: one_member_abstracts

abstract class Service {
	Future<void> init();
}
