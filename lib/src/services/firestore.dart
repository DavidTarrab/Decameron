import "package:cloud_firestore/cloud_firestore.dart";

import "database.dart";
export "database.dart";

class CloudFirestore extends Database {
	static final FirebaseFirestore firestore = FirebaseFirestore.instance;

	static final CollectionReference storiesCollection = 
		firestore.collection("stories");

	@override
	Future<void> init() async {}

	@override
	Future<List<Map<String, dynamic>>> getRandomStories(int n) async {
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
}