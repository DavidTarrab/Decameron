import "package:flutter/material.dart";

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
