import "package:flutter/material.dart";
import "package:decameron/models.dart";
import "package:decameron/services.dart";

/// A widget that puts a [TextFormField] next to a [Text] label. 
class FormRow extends StatelessWidget {
	/// The label to show. 
	final String label;

	/// A smaller hint under the label. 
	final String subtitle;

	/// A callback for when [FormState.save] is called. 
	final void Function(String) onSaved;

	/// A function to validate the entered string.
	final FormFieldValidator<String> validator;

	/// Puts a textbox next to a label.
	const FormRow({
		@required this.onSaved,
		@required this.label,
		this.subtitle,
		this.validator,
	});

	@override
	Widget build(BuildContext context) => Padding(
		padding: const EdgeInsets.symmetric(vertical: 10), 
		child: Row(
			children: [
				Expanded(
					flex: 1, 
					child: ListTile(
						title: Text(label),
						subtitle: Text(subtitle ?? ""),
					)
				),
				Expanded(
					flex: 2,
					child: TextFormField(onSaved: onSaved, validator: validator)
				),
			]
		)
	);
}


/// A page to create and upload a new story. 
class StoryUploaderPage extends StatefulWidget {
	@override
	StoryUploaderState createState() => StoryUploaderState();
}

/// A state to manage all the individual fields of [StoryUploaderPage]. 
class StoryUploaderState extends State<StoryUploaderPage> {
	/// The model that builds the story field by field. 
	StoryBuilderModel model = StoryBuilderModel();

	/// If the page is loading. 
	bool isLoading = false;

	@override
	Widget build(BuildContext context) => Scaffold(
		appBar: AppBar(title: const Text("Tell a story")),
		floatingActionButton: !isLoading ? null : FloatingActionButton(
			onPressed: null,
			child: CircularProgressIndicator(
				valueColor: AlwaysStoppedAnimation(  // has to be an animation
					Theme.of(context).colorScheme.onSecondary
				)
			),
		),
		body: Form(
			autovalidateMode: AutovalidateMode.onUserInteraction, 
			child: Center(child: 
				ConstrainedBox(
					constraints: const BoxConstraints(maxWidth: 750),
					child: ListView(
						padding: const EdgeInsets.all(10),
						children: [
							const SizedBox(height: 10),
							FormField<void>(
								// onSaved: (void _) => model.uid = Services.instance.auth.uid,
								onSaved: (_) {},
								builder: (_) => Container(),
							),
							FractionallySizedBox( 
								widthFactor: 2/3,
								child: TextFormField(
									onSaved: (String value) => model.title = value,
									textAlign: TextAlign.center, 
									decoration: const InputDecoration(
										hintText: "Your amazing story",
										border: OutlineInputBorder(),
									),
								)
							),
							const SizedBox(height: 20),
							const AspectRatio(
								aspectRatio: 1.5,
								child: Placeholder()
							),
							const SizedBox(height: 50),
							FormRow(
								label: "Catchy first sentence",
								onSaved: (String value) => model.firstSentence = value,
							),
							FormRow(
								label: "Your name",
								subtitle: "First name and last initial",
								validator: (String value) => value.contains(" ") 
									? null : "Please enter your first name and last initial",
								onSaved: (String value) {
									final List<String> parts = value.split(" ");
									model
										..firstName = parts [0]
										..lastInitial = parts [1] [0];
								}
							),
							const SizedBox(height: 20),
							const Text("Type out the full story here"),
							const SizedBox(height: 10),
							TextFormField(
								onSaved: (String value) => model.text = value,
								maxLines: null,
								decoration: const InputDecoration(
									filled: true,
									border: OutlineInputBorder()
								),
							),
							const SizedBox(height: 20),
							Builder(
								builder: (BuildContext context) => SizedBox(
									width: 100, child: RaisedButton(
										onPressed: () => upload(context),
										child: const Text("Upload"),
									)
								)
							)
						]
					)
				)
			)
		)
	);

	/// Uploads the story inputted by the user. 
	Future<void> upload(BuildContext context) async {
		setState(() => isLoading = true);
		try {
			Form.of(context).save();
			await Models.instance.stories.upload(model.story);
		} catch (error) {  // ignore: avoid_catches_without_on_clauses
			Scaffold.of(context).showSnackBar(
				SnackBar(
					content: const Text("Error while uploading story"),
					action: SnackBarAction(
						label: "RETRY",
						onPressed: () => upload(context),
					)
				)
			);
			setState(() => isLoading = false);
			rethrow;
		}
		setState(() => isLoading = false);
	}
}
