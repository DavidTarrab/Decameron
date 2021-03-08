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
        isAllowed: () => Models.instance.user.hasData
      ), 
      Routes.moderator: (_) => RouteInitializer(
        builder: (_) => ModeratorPage(),
        isAllowed: () => Models.instance.user.isModerator,
      ),
      Routes.user: (_) => RouteInitializer(
        builder: (_) => UserPage(),
        isAllowed: () => Models.instance.user.hasData
      )
    }
  );
}
