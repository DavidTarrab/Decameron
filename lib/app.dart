import "package:flutter/material.dart";

import "package:decameron/models.dart";
import "package:decameron/pages.dart";
import "package:decameron/services.dart";

/// The Decameron app. 
/// 
/// Define the main theme and routing logic here.
class Decameron extends StatefulWidget {
  @override
  DecameronState createState() => DecameronState();
}

/// Initializes the services and data models for the app. 
class DecameronState extends State<Decameron> {
  /// Whether the data is ready for the app to use. 
  bool isReady = false;

  @override
  void initState() {
    super.initState();
    // [init] is a Future, but this function is not async. 
    // So we have to use the `then` callback. 
    init().then(
      (void _) => setState(() => isReady = true)
    );
  }

  /// Initializes the services and data models. 
  Future<void> init() async {
    await Services.instance.init();
    await Models.instance.init();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: "Decameron",
    theme: ThemeData(
      primarySwatch: Colors.red,
      scaffoldBackgroundColor: Colors.black,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: isReady 
      ? HomePage()
      : const Center(child: CircularProgressIndicator()),
    routes: {
      Routes.home: (_) => HomePage(),
      Routes.upload: (_) => UploadPage(),
    },
  );
}
