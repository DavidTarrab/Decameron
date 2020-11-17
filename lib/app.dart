import "package:flutter/material.dart";

import "package:decameron/pages.dart";

/// The Decameron app. 
/// 
/// Define the main theme and routing logic here.
class Decameron extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: "Decameron",
    theme: ThemeData(
      primarySwatch: Colors.red,
      scaffoldBackgroundColor: Colors.black,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: HomePage(),
  );
}
