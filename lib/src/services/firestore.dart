import "package:cloud_firestore/cloud_firestore.dart";

import "service.dart";

extension on Query {
	Future<List<Map>> getData() async {
		final QuerySnapshot snapshot = await get();
		final List<QueryDocumentSnapshot> documents = snapshot.docs;
		return [
			for (final QueryDocumentSnapshot document in documents)
				document.data()
		];
	}
}

/// Provides access to the Cloud Firestore database. 
class Database extends Service {
	/// The Firestore plugin. 
	static final FirebaseFirestore firestore = FirebaseFirestore.instance;

	/// The stories collection. 
	final CollectionReference storiesCollection = 
		firestore.collection("stories");

	final CollectionReference authorsCollection = 
		firestore.collection("authors");

	@override
	Future<void> init() async {}

	/// Gets a random ID for a new story.
	/// 
	/// Use this function to get an ID before uploading a document.
	String getRandomStoryId() => storiesCollection.doc().id;

	Future<List<Map>> getRandomStories(int n) async {
		final String randomKey = getRandomStoryId();
		final List<Map> result = [];
		final Query approvedStories = storiesCollection
			.where("isApproved", isEqualTo: true);

		Future<List<Map>> addDocuments({bool ascending}) async {
			final Query randomQuery = (ascending 
				? approvedStories.where(
					FieldPath.documentId, 
					isGreaterThanOrEqualTo: randomKey
				) 
				: approvedStories.where(
					FieldPath.documentId, 
					isLessThan: randomKey
				)
			).limit(n - result.length);

			return randomQuery.getData();
		}
		
		return [
			...await addDocuments(ascending: true),
			...await addDocuments(ascending: false),
		];
	}

	Future<List<Map>> get pendingStories => storiesCollection
		.where("isApproved", isEqualTo: false)
		.limit(10)
		.getData();

	Future<List<Map>> getStoriesByAuthor(String uid) => storiesCollection
		.where("isApproved", isEqualTo: true)
		.where("author.uid", isEqualTo: uid)
		.getData();

	Future<Map> getAuthor(String uid) async =>
		(await authorsCollection.doc(uid).get()).data();

	Future<void> uploadStory(Map storyJson) async {
		await storiesCollection.doc(storyJson ["id"]).set(storyJson);
		final Map authorJson = storyJson["author"];
		await authorsCollection.doc(authorJson ["uid"]).set(authorJson);
	}

	Future<void> deleteStory(String id) => 
		storiesCollection.doc(id).delete();

	Future<void> approveStory(String id) => storiesCollection
		.doc(id).update({"isApproved": true});
}
