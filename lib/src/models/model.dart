import "package:flutter/foundation.dart" show ChangeNotifier;

/// Defines a data model. 
/// 
/// A data model is a class that has access to services and structured data. In 
/// other words, the `models` library comes after the `data` and `services` 
/// libraries. Most logic happens in data models. 
/// 
/// Data models can implement [init] to initialize themselves with services, and
/// [dispose] to dispose of resources. [init] is the first function to be called
/// and [dispose] is guaranteed to be the last. 
// ignore: prefer_mixin
abstract class Model with ChangeNotifier {
	/// Initializes the model. 
	/// 
	/// At this point, the model will have access to services. 
	Future<void> init();
}
