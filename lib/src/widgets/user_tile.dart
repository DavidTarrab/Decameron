import "package:flutter/material.dart";

import "package:decameron/models.dart";

import "model_listener.dart";

/// A small tile to show the user their authentication status. 
class UserTile extends StatefulWidget {
	@override
	UserTileState createState() => UserTileState();
}

/// The state for [UserTile]. Allows the user to sign in or out. 
class UserTileState extends State<UserTile> {
	/// If the user is signing in or out. 
	bool isLoading = false;

	@override
	Widget build(BuildContext context) => ModelListener<UserModel>(
		model: () => Models.instance.user,
		shouldDispose: false,
		builder: (_, UserModel model, __) => model.isSignedIn
			? ListTile(
					title: Text("Welcome, ${model.author.first}"),
					leading: isLoading 
						? const CircularProgressIndicator() 
						: CircleAvatar(child: Text(model.author.first [0])),
					trailing: TextButton(
						child: const Text("Sign out"),
						onPressed: () => signOut(model),
					),
				)
			: ListTile(
					title: const Text("You're not signed in"),
					leading: isLoading ? const CircularProgressIndicator() : null,
					trailing: TextButton(
						onPressed: () => signIn(model),
						child: const Text("Sign in"),
					)
				)
	);

	/// Signs the user in. 
	/// 
	/// This function defers to [UserModel.signIn].
	Future<void> signIn(UserModel model) async {
		setState(() => isLoading = true);
		try {
			await model.signIn();
		} catch (error) {  // ignore: avoid_catches_without_on_clauses
			Scaffold.of(context).showSnackBar(
				const SnackBar(content: Text("Couldn't sign in"))
			);
		}
		setState(() => isLoading = false);
	}

	/// Signs the user out.
	/// 
 	/// This function defers to [UserModel.signOut].
	Future<void> signOut(UserModel model) async {
		setState(() => isLoading = true);
		await model.signOut();
		setState(() => isLoading = false);
	}
}
