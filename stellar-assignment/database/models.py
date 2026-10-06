from database.db import db


class Snippets(db.Document):
    url = db.StringField(required=True)
    name = db.StringField(required=True, unique=True)
    expires_at = db.DateTimeField(required=True, unique=False)
    snippet = db.StringField(required=True, unique=False)
    expires_in = db.LongField(required=True, unique=False)
    likes = db.LongField(required=False)
