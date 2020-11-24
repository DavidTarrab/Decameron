import "package:cloud_firestore/cloud_firestore.dart";

import "database.dart";
export "database.dart";

/// Implements the [Database] interface with Cloud Firestore. 
class CloudFirestore extends Database {
	/// The Firestore plugin. 
	static final FirebaseFirestore firestore = FirebaseFirestore.instance;

	/// The stories collection. 
	static final CollectionReference storiesCollection = 
		firestore.collection("stories");

	@override
	Future<void> init() async {}

	@override
	Future<List<Map>> getRandomStories(int n) async {
		final String randomKey = storiesCollection.doc().id;
		final Query query = storiesCollection
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
	Future<void> uploadStory(Map json) async => 
		storiesCollection.doc().set(json);
}