import "package:flutter/material.dart";

import "package:decameron/models.dart";
import "package:decameron/services.dart";
import "package:decameron/pages.dart";

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    try {
      await Services.instance.init();
      await Models.instance.init();
      await Navigator.of(context).pushReplacementNamed(Routes.home);
    } catch (error) {
      await Navigator.of(context).pushReplacementNamed(Routes.error);
    }
  }

  @override
  Widget build(BuildContext context) => 
    const Center(child: CircularProgressIndicator());
}
