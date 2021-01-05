import "package:cloud_firestore/cloud_firestore.dart";

import "package:decameron/services.dart";

import "database.dart";
export "database.dart";

/// Implements the [Database] interface with Cloud Firestore. 
class CloudFirestore extends Database {
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

	@override
	String getRandomStoryId() => storiesCollection.doc().id;

	@override
	Future<List<Map>> getRandomStories(int n) async {
		final String randomKey = storiesCollection.doc().id;
		final Query query = storiesCollection
			.where("isApproved", isEqualTo: true)
			.where(FieldPath.documentId, isGreaterThanOrEqualTo: randomKey)
			.limit(n);
		final QuerySnapshot stories = await query.get();
		final List<QueryDocumentSnapshot> snapshots = stories.docs;
		return [
			for (final QueryDocumentSnapshot snapshot in snapshots)
				snapshot.data()
		];
	}

	@override
	Future<void> uploadStory(Map json, String id) => 
		storiesCollection.doc(id).set(Map<String, dynamic>.from(json));

	@override
	Future<Map<String, dynamic>> get userProfile async => 
		(await userDocument.get()).data();

	@override
	Future<void> setProfile(Map json) => 
		userDocument.set(Map<String, dynamic>.from(json));
}