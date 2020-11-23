import "package:flutter/material.dart";

/// A [WidgetBuilder], but with a [ChangeNotifier] and optional child. 
typedef ModelBuilder<Model extends ChangeNotifier> = 
	Widget Function(BuildContext context, Model model, Widget child);

/// A widget that rebuilds when a data model updates. 
class ModelListener<Model extends ChangeNotifier> extends StatefulWidget {
	/// A function to build the widget tree using the model. 
	final ModelBuilder<Model> builder;

	/// A function to create the model. 
	final Model Function() model;

	/// An optional child. 
	/// 
	/// If a part of the widget tree does not depend on the model, you can pass
	/// it to this widget as the child parameter to cache it. 
	final Widget child;

	/// Whether this widget should dispose the model when the widget is disposed. 
	final bool shouldDispose;

	/// Creates a widget that updates when the underlying data changes. 
	const ModelListener({
		@required this.model,
		@required this.builder,
		this.shouldDispose = true,
		this.child,
	});

	@override
	ModelListenerState createState() => ModelListenerState<Model>();
}

/// The state for a [ModelListener]. 
/// 
/// This class is in charge of creating and disposing the model, as well 
/// as listening to it for updates. 
class ModelListenerState<Model extends ChangeNotifier>
	extends State<ModelListener<Model>> 
{
	/// The model representing the underlying data. 
	Model model;

	/// Rebuilds the widget tree when the underlying data changes. 
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
