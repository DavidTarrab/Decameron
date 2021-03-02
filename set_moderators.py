import firebase_admin
from firebase_admin import credentials, auth

MODERATOR_EMAILS = {
	"leschesl@ramaz.org",
	"jjucovy@gmail.com",
	"rabhan@ramaz.org",
	"tarrabd@ramaz.org",
}

cred = credentials.Certificate("firebase_credentials.json")
firebase_admin.initialize_app(cred)
for email in MODERATOR_EMAILS:
	uid = auth.get_user_by_email(email).uid
	print(f"Making {email} a moderator. UID = {uid}")
	auth.set_custom_user_claims(uid, {'isModerator': True})
