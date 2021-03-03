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
    initialRoute: Routes.splash,
    onGenerateRoute: (RouteSettings settings) => 
      MaterialPageRoute(builder: getRoute(settings.name))
  );

  WidgetBuilder getRoute(String name) {
    if (!isReady) {
      return (_) => SplashScreen();
    }
    switch (name) {
      case Routes.splash: return (_) => SplashScreen();
      case Routes.error: return (_) => ErrorPage();
      case Routes.home: return (_) => HomePage();
      case Routes.upload: 
        if (Models.instance.user.hasData) {
          return (_) => StoryUploaderPage();
        }
        break;
      case Routes.moderator: 
        if (Models.instance.user.isModerator) {
          return (_) => ModeratorPage();
        }
        break;
    }
    return (_) => HomePage();  // default to HomePage
  } 
}
