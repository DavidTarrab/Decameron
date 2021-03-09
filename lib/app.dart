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
  bool get isReady => Services.instance.isReady
    && Models.instance.isReady;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: "Decameron",
    theme: ThemeData(
      primarySwatch: Colors.red,
      accentColor: Colors.orange,
      scaffoldBackgroundColor: Colors.black,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      brightness: Brightness.dark,
    ),
    initialRoute: Routes.home,
    routes: {
      Routes.error: (_) => ErrorPage(),
      Routes.home: (_) => RouteInitializer(builder: (_) => HomePage()),
      Routes.about: (_) => AboutPage(),
      Routes.upload: (_) => RouteInitializer(
        builder: (_) => StoryUploaderPage(),
        isAllowed: () => Models.instance.user.isSignedIn
      ), 
      Routes.moderator: (_) => RouteInitializer(
        builder: (_) => ModeratorPage(),
        isAllowed: () => Models.instance.user.isModerator,
      ),
    },
    onGenerateRoute: (RouteSettings settings) {
      final List<String> path = settings.name.split("/");
      final String prefix = path.first;
      switch (prefix) {
        case "author": return MaterialPageRoute(
          builder: (_) => UserPage(uid: path.last),
          settings: settings,
        );
        default: return MaterialPageRoute(
          builder: (_) => ErrorPage(),
          settings: settings,
        );
      }
    },
  );
}
