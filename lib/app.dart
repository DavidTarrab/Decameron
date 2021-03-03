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
  Future<bool> initFuture;

  @override
  void initState() {
    super.initState();
    initFuture = init();
  }

  /// Initializes the services and data models. 
  Future<bool> init() async {
    try {
      await Services.instance.init();
      await Models.instance.init();
      return true;
    } catch (error) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: "Decameron",
    theme: ThemeData(
      primarySwatch: Colors.red,
      scaffoldBackgroundColor: Colors.black,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      brightness: Brightness.dark,
    ),
    home: FutureBuilder<void>(
      future: initFuture,
      builder: (_, AsyncSnapshot snapshot) => !snapshot.hasData
        ? const Center(child: CircularProgressIndicator())
        : snapshot.data 
          ? HomePage()
          : ErrorPage()
    ),
    routes: {
      Routes.home: (_) => HomePage(),
      Routes.upload: (_) => StoryUploaderPage(),
      Routes.moderator: (_) => ModeratorPage(),
    },
  );
}

class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "We're experiencing some issues", 
            style: Theme.of(context).textTheme.headline2
          ),
          const SizedBox(height: 50),
          Text(
            "Please try again later", 
            style: Theme.of(context).textTheme.headline4
          ),
        ],
      )
    )
  );
}
