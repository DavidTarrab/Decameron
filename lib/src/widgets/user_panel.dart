import "package:flutter/material.dart";

import "package:decameron/models.dart";
import "package:decameron/pages.dart";

import "model_listener.dart";

/// A ListTile that can be a little wider than usual. 
/// 
/// Under some conditions, [ListTile] will try to expand horizontally 
/// without limit. Using [IntrinsicWidth] helps, but if [ListTile.trailing]
/// is wide, it will cut off [ListTile.title]. 
/// 
/// This widget uses a [Row] with proper padding instead of a ListTile. By using
/// [MainAxisSize.min], we ensure that the widget will not try to expand.
class WiderListTile extends StatelessWidget {
	/// The label for this tile. 
	/// 
	/// Equivalent to [ListTile.title].
	final String label;

	final String subtitle;

	/// The leading widget. 
	/// 
	/// Equivalent to [ListTile.leading]. 
	final Widget leading;

	/// The trailing widget.
	/// 
	/// Equivalent to [ListTile.trailing].
	final Widget trailing;

	final VoidCallback onTap;

	/// Creates a Row that imitates a ListTile. 
	const WiderListTile({
		@required this.label,
		@required this.leading,
		@required this.trailing,
		this.subtitle,
		this.onTap,
	});

	@override
	Widget build(BuildContext context) => InkWell(
		onTap: onTap,
		child: Padding(
			padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
			child: Row(
				mainAxisSize: MainAxisSize.min,
				children: [
					if (leading != null) leading, 
					const SizedBox(width: 16),
					Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							Text(label, maxLines: 1),
							if (subtitle != null)
								Text(subtitle, maxLines: 1, style: Theme.of(context).textTheme.caption),
						]
					),
					const SizedBox(width: 32),
					if (trailing != null) trailing,
				]
			)
		)
	);
}

/// A small tile to show the user their authentication status. 
class UserTile extends StatefulWidget {
	final User model;
	const UserTile(this.model);

	@override
	UserTileState createState() => UserTileState();
}

/// The state for [UserTile]. Allows the user to sign in or out. 
class UserTileState extends State<UserTile> {
	/// If the widget is loading. 
	bool isLoading = false;

	@override
	Widget build(BuildContext context) => Container(
		decoration: BoxDecoration(
			border: Border.all(color: Colors.white),
			borderRadius: BorderRadius.circular(10),
		),
		child: widget.model.isSignedIn
			? WiderListTile(
					label: "Welcome, ${widget.model.author.first}",
					leading: isLoading 
						? const CircularProgressIndicator() 
						: CircleAvatar(radius: 16, child: Text(widget.model.author.first [0])),
					subtitle: "Click to see your stories",
					onTap: () => Navigator.of(context).pushNamed(Routes.user),
					trailing: TextButton(
						child: const Text("Sign out"),
						onPressed: () => signOut(widget.model),
					),
				)
			: WiderListTile(
					label: "You're not signed in",
					leading: isLoading ? const CircularProgressIndicator() : null,
					trailing: TextButton(
						onPressed: () => signIn(widget.model),
						child: const Text("Sign in"),
					)
				)
	);

	/// Signs the user in. 
	/// 
	/// This function defers to [User.signIn].
	Future<void> signIn(User model) async {
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
 	/// This function defers to [User.signOut].
	Future<void> signOut(User model) async {
		setState(() => isLoading = true);
		await model.signOut();
		setState(() => isLoading = false);
	}
}

class UserPanel extends StatelessWidget {
	@override
	Widget build(BuildContext context) => ModelListener<User>(
		model: () => Models.instance.user,
		shouldDispose: false,
		builder: (_, User model, __) => Container(
			padding: const EdgeInsets.all(10),
			alignment: Alignment.topLeft,
			child: Column(
				children: [
					UserTile(model),
					const SizedBox(height: 10),
					if (
						model.isModerator 
						&& Models.instance.moderator.pendingStories.isNotEmpty
					) ModelListener<Moderator>(
						model: () => Models.instance.moderator,
						shouldDispose: false,
						builder: (_, Moderator moderatorModel, __) => TextButton.icon(
							icon: const Icon(Icons.fact_check),
							onPressed: () => Navigator.of(context)
								.pushNamed(Routes.moderator),
							label: Text(
								"Click to moderate pending stories", 
								style: Theme.of(context).textTheme.button,
							),
						)
					),
				]
			)
		)
	);
}
