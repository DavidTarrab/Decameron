# Firebase Rules

### Firestore

- To test the Firestore rules, run this command: 

		firebase emulators:exec --only firestore "npm test"

- Alternatively, start up the emulators and run the tests separately: 

		firebase emulators:start --only firestore
		npm test

- To deploy the Firestore rules, run this command:

		firebase deploy --only firestore:rules
