import "package:flutter/material.dart";

typedef ModelBuilder<Model extends ChangeNotifier> = 
	Widget Function(BuildContext context, Model model, Widget child);

class ModelListener<Model extends ChangeNotifier> extends StatefulWidget {
	final ModelBuilder<Model> builder;
	final Model Function() model;
	final Widget child;
	final bool shouldDispose;

	const ModelListener({
		@required this.model,
		@required this.builder,
		this.shouldDispose = true,
		this.child,
	});

	@override
	ModelListenerState createState() => ModelListenerState<Model>();
}

class ModelListenerState<Model extends ChangeNotifier>
	extends State<ModelListener<Model>> 
{
	ChangeNotifier model;

	void listener() => setState(() {});

	@override
	void initState() {
		super.initState();
		model = widget.model()..addListener(listener);
	}

	@override
	void dispose() {
		model.removeListener(listener);
		if (widget.shouldDispose) {
			model.dispose();
		}
		super.dispose();
	}

	@override
	Widget build(BuildContext context) => 
		widget.builder(context, model, widget.child);
}
