import "package:flutter/foundation.dart" show ChangeNotifier;

// ignore: prefer_mixin
abstract class Model with ChangeNotifier {
	Future<void> init();
}
