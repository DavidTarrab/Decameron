import "package:flutter/material.dart";

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

	/// The text controller for this text field. 
	final TextEditingController controller;

	/// Puts a textbox next to a label.
	const FormRow({
		@required this.onSaved,
		@required this.label,
		this.subtitle,
		this.validator,
		this.controller,
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
					child: TextFormField(
						onSaved: onSaved, 
						validator: validator, 
						controller: controller
					)
				),
			]
		)
	);
}
