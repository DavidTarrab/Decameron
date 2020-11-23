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

class DecameronState extends State<Decameron> {
  bool isReady = false;

  @override
  void initState() {
    super.initState();
    init().then(
      (void _) => setState(() => isReady = true)
    );
  }

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
      : const Center(child: CircularProgressIndicator())
  );
}
