const firebase = require("@firebase/rules-unit-testing");
const fs = require("fs");

console.warn = function(str) {}

const PROJECT_ID = "decameron";
const COVERAGE_URL = `http://localhost:8080/emulator/v1/projects/${PROJECT_ID}:ruleCoverage.html`;

const approvedStory = {isApproved: true, author: {uid: "Hello"}}
const unapprovedStory = {isApproved: false, author: {uid: "Hello"}}

function getFirestore(auth) {return firebase
	.initializeTestApp({ projectId: PROJECT_ID, auth })
  .firestore();
}

before(async () => {
	// Load the rules file before the tests begin
	const rules = fs.readFileSync("firestore.rules", "utf8");
	await firebase.loadFirestoreRules({ projectId: PROJECT_ID, rules });

	const adminApp = firebase.initializeAdminApp( {projectId: PROJECT_ID });
	const firestore = adminApp.firestore();

	const storiesCollection = firestore.collection("stories");
	await storiesCollection.doc("approved-story").set(approvedStory);
	await storiesCollection.doc("unapproved-story").set(unapprovedStory);
});

after(async () => {
	await Promise.all(firebase.apps().map((app) => app.delete()));
	console.log(`View firestore rule coverage information at ${COVERAGE_URL}\n`);
});

describe("Unauthenticated users", () => {
	const firestore = getFirestore(null);
	const storiesCollection = firestore.collection("stories");

	it("Regular users can only get approved stories", async () => {
		await firebase.assertSucceeds(storiesCollection.doc("approved-story").get());
		await firebase.assertFails(storiesCollection.doc("unapproved-story").get());
	});

	it("Regular users can only query approved stories", async () => {
		const goodQuery = storiesCollection.where("isApproved", "==", true);
		const badQuery = storiesCollection.where("isApproved", "==", false);
		await firebase.assertSucceeds(goodQuery.get());
		await firebase.assertFails(badQuery.get());
		// Must at least account for approved queries
		await firebase.assertFails(storiesCollection.get());
	});

	it("Unauthenticated users cannot write any stories", async () => {
		const newDoc = storiesCollection.doc("new-story");
		const existingDoc = storiesCollection.doc("approved-story");
		await firebase.assertFails(newDoc.set(approvedStory));
		await firebase.assertFails(existingDoc.set(approvedStory));
		await firebase.assertFails(existingDoc.delete());
	});
});

describe("Signed-in users", () => {
	const alice = {uid: "alice"};
	const bob = {uid: "bob"};
	const firestoreAlice = getFirestore(alice);
	const storiesCollection = firestoreAlice.collection("stories");

	const aliceStory = {
		author: alice, 
		isApproved: false, 
		title: "Title",
	};

	const aliceUpdatedStory = {
		author: alice, 
		isApproved: false, 
		title: "Updated title",
	}

	it("Users can upload their own stories", async() => {
		const doc = storiesCollection.doc();
		await firebase.assertSucceeds(doc.set(aliceStory));
		await doc.delete();
	});

	it("Users can modify and delete their own stories", async() => {
		const doc = storiesCollection.doc();
		await doc.set(aliceStory);
		await firebase.assertSucceeds(doc.set(aliceUpdatedStory));
		await firebase.assertSucceeds(doc.delete());
	});

	describe("Write restrictions", async() => {
		it("Users cannot modify or delete other people's stories", async() => {
			const docAlice = storiesCollection.doc();
			const id = docAlice.id;
			await docAlice.set(aliceStory);

			const firestoreBob = getFirestore(bob);
			const docBob = firestoreBob.collection("stories").doc(id);
			await firebase.assertFails(docBob.set(aliceUpdatedStory));
			await firebase.assertFails(docBob.set({
				author: bob, 
				isApproved: false,
				title: "Title",
			}));
			await firebase.assertFails(docBob.delete());
			await docAlice.delete();
		});

		it("Users cannot change the author of their own story", async () => {
			const doc = storiesCollection.doc();
			await doc.set(aliceStory);

			await firebase.assertFails(doc.set({
				author: bob,
				isApproved: false,
				title: "Title",
			}));
			await doc.delete();
		});

		it("User stories must be unapproved", async() => {
			const doc = storiesCollection.doc();
			const approvedStoryAlice = {
				author: alice,
				isApproved: true,
				title: "Title",
			};
			await firebase.assertFails(doc.set(approvedStoryAlice));

			// Cannot update the story as approved
			await doc.set(aliceStory);
			await firebase.assertFails(doc.set(approvedStoryAlice));
			await doc.delete();
		});
	});
});

describe("Moderators", () => {
	const user = {uid: "user"};
	const firestoreUser = getFirestore(user);
	const userDoc = firestoreUser.collection("stories").doc();
	const id = userDoc.id;

	before(async() => {
		await userDoc.set({
			author: user,
			isApproved: false,
		});
	});

	after(async() => {
		await userDoc.delete();
	});

	const moderator = {uid: "moderator", "isModerator": true};
	const firestore = getFirestore(moderator);
	const storiesCollection = firestore.collection("stories");
	const doc = storiesCollection.doc(id);

	it("Moderators can query all documents", async () => {
		const query = storiesCollection.where("isApproved", "==", true);
		await firebase.assertSucceeds(query.get());
		await firebase.assertSucceeds(storiesCollection.get());
	});

	it("Moderators can approve stories", async () => {
		await firebase.assertSucceeds(doc.set(
			{isApproved: true, author: user}
		));
	});

	it("Moderators cannot change authors", async () => {
		await firebase.assertFails(doc.set(
			{author: moderator, isApproved: true}
		));
	});

	it("Moderators can delete anyone's story", async () => {
		const newDoc = firestoreUser.collection("stories").doc();
		await newDoc.set({
			author: user,
			isApproved: false,
		});
		await firebase.assertSucceeds(newDoc.delete());
	});
});
