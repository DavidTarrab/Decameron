import "package:cloud_firestore/cloud_firestore.dart";

import "package:decameron/services.dart";

import "service.dart";

/// Provides access to the Cloud Firestore database. 
class Database extends Service {
	/// The Firestore plugin. 
	static final FirebaseFirestore firestore = FirebaseFirestore.instance;

	/// The stories collection. 
	final CollectionReference storiesCollection = 
		firestore.collection("stories");

	/// The users collection. 
	final CollectionReference usersCollection = 
		firestore.collection("users");

	/// The user profile document for this user.
	DocumentReference get userDocument => 
		usersCollection.doc(Services.instance.auth.uid);

	@override
	Future<void> init() async {}

	/// Gets a random ID for a new story.
	/// 
	/// Use this function to get an ID before uploading a document.
	String getRandomStoryId() => storiesCollection.doc().id;

	/// Gets n random stories from the database. 
	Future<List<Map>> getRandomStories(int n) async {
		final String randomKey = getRandomStoryId();
		final List<QueryDocumentSnapshot> snapshots = [];
		final Query approvedStories = storiesCollection
			.where("isApproved", isEqualTo: true);

		Future<void> addSnapshots({bool ascending}) async {
			final Query randomQuery = (ascending 
				? approvedStories.where(
					FieldPath.documentId, 
					isGreaterThanOrEqualTo: randomKey
				) 
				: approvedStories.where(
					FieldPath.documentId, 
					isLessThan: randomKey
				)
			).limit(n - snapshots.length);
			snapshots.addAll((await randomQuery.get()).docs);
		}
		
		await addSnapshots(ascending: true);
		await addSnapshots(ascending: false);

		return [
			for (final QueryDocumentSnapshot snapshot in snapshots)
				snapshot.data()
		]..shuffle();
	}

	Future<List<Map>> get pendingStories async {
		final Query query = storiesCollection
			.where("isApproved", isEqualTo: false).limit(10);
		final QuerySnapshot snapshot = await query.get();
		return [
			for (final QueryDocumentSnapshot document in snapshot.docs)
				document.data()
		];
	}

	/// Uploads a story to the database. 
	Future<void> uploadStory(Map json, String id) async {
		await storiesCollection.doc(id).set(Map<String, dynamic>.from(json));
		await userDocument.set(
			{"stories": FieldValue.arrayUnion([id])}, 
			SetOptions(merge: true)
		);
	}

	Future<void> approveStory(String id) async {
		final DocumentReference document = storiesCollection.doc(id);
		await document.update({"isApproved": true});
	}

	Future<void> deleteStory(String id, String authorUID) async {
		await storiesCollection.doc(id).delete();
		await usersCollection.doc(authorUID).update(
			{"stories": FieldValue.arrayRemove([id])},
		);
	}
}
