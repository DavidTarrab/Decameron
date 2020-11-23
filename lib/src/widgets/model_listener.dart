import "package:flutter/material.dart";

typedef ModelBuilder<Model extends ChangeNotifier> = 
	Widget Function(BuildContext, Model, [Widget]);

class ModelListener<Model extends ChangeNotifier> extends StatefulWidget {
	final ModelBuilder<Model> builder;
	final Model Function() model;
	final Widget child;

	const ModelListener({
		@required this.model,
		@required this.builder,
		this.child,
	});

	@override
	ModelListenerState createState() => ModelListenerState();
}

class ModelListenerState<Model extends ChangeNotifier> 
	extends State<ModelListener<Model>> 
{
	Model model;

	@override
	void initState() {
		super.initState();
		model = widget.model();
	}

	@override
	void dispose() {
		model.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) => 
		widget.builder(context, model, widget.child);
}
