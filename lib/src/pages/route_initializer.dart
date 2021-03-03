import "package:flutter/material.dart";

import "package:decameron/pages.dart";
import "package:decameron/models.dart";
import "package:decameron/services.dart";

class RouteInitializer extends StatefulWidget {
	static bool alwaysTrue () => true;
	final WidgetBuilder builder;
	final Widget loadingWidget;
	final bool Function() isAllowed;

	const RouteInitializer({
		@required this.builder,
		this.loadingWidget = const Center(child: CircularProgressIndicator()),
		this.isAllowed = alwaysTrue,
	});

	@override
	RouteInitializerState createState() => RouteInitializerState();
}

class RouteInitializerState extends State<RouteInitializer> {
	Future initFuture;

	@override
	void initState() {
		super.initState();
		initFuture = init();
	}

	Future<void> init() async {
		try {
			if (!Models.instance.isReady) {
				await Services.instance.init(); 
				await Models.instance.init();
			}
		} catch (error) {
			await Navigator.of(context).pushReplacementNamed(Routes.error);
		}
		if (!widget.isAllowed()) {
			await Navigator.of(context).pushReplacementNamed(Routes.home);
		}
	}

	@override
	Widget build(BuildContext context) => FutureBuilder(
		future: initFuture,
		builder: (_, AsyncSnapshot snapshot) =>
			snapshot.connectionState == ConnectionState.done
				? widget.builder(context) : widget.loadingWidget
	);
}
