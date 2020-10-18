import 'package:flutter/material.dart';
import "dart:async"; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Decameron',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Decameron Home Page'),
    );
  }
}

class SmokeFade extends StatefulWidget {

  final int startDelay;
  final int endDelay;
  final int fadeInDuration;
  final int fadeOutDuration;
  final String fadeText;

  SmokeFade ({
    @required this.startDelay,
    @required this.endDelay,
    @required this.fadeInDuration,
    @required this.fadeOutDuration,
    @required this.fadeText,
  });

  @override
  createState() => SmokeFadeState();
}

class SmokeFadeState extends State<SmokeFade> {

  double opacityLevel = 0.0;

  void _fadeIn() {
    setState(() => opacityLevel = 1.0);
  }

  void _fadeOut() {
    setState(() => opacityLevel = 0.0);
  }

  void _fade() {
  	Timer(Duration(seconds: widget.startDelay), _fadeIn);
  	Timer(Duration(seconds: widget.endDelay + widget.startDelay + widget.fadeInDuration), _fadeOut);
  }

  @override
  void initState() {
  	super.initState();
  	_fade();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedOpacity(
          opacity: opacityLevel,
          duration: Duration(seconds: widget.fadeInDuration),
          child: Text(widget.fadeText),
        ),
      ],
    );
  }
}


class SmokeAnim extends StatefulWidget {
  SmokeAnim({Key key}) : super(key: key);

  @override
  _SmokeAnimState createState() => _SmokeAnimState();
}

/// This is the private State class that goes with SmokeAnim.
/// AnimationControllers can be created with `vsync: this` because of TickerProviderStateMixin.
class _SmokeAnimState extends State<SmokeAnim>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double smallLogo = 10.0;
    final double bigLogo = 20.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final Size biggest = constraints.biggest;
        return Stack(
          children: [
            PositionedTransition(
              rect: RelativeRectTween(
                begin: RelativeRect.fromSize(
                    Rect.fromLTWH(0, 0, smallLogo, smallLogo), biggest),
                end: RelativeRect.fromSize(
                    Rect.fromLTWH(biggest.width - bigLogo,
                        biggest.height - bigLogo, bigLogo, bigLogo),
                    biggest),
              ).animate(CurvedAnimation(
                parent: _controller,
                curve: Curves.ease,
              )),
              child: Padding(
                  padding: const EdgeInsets.all(8), 
                  child: FlutterLogo()),
            ),
          ],
        );
      },
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            
          	SmokeFade(
          	  startDelay : 2,
          	  endDelay : 5, 
          	  fadeInDuration : 1, 
          	  fadeOutDuration : 8,
          	  fadeText : 'story sentence',
          	),

          	//SmokeAnim(),

          	Padding(
              padding: EdgeInsets.all(10),
              child: Image.network('https://www.clipartmax.com/png/middle/224-2242893_cartoon-campfire-gif-campfire-gif-transparent-background.png'),
        	),  
          ],
        ),
      ),
    );
  }
}

