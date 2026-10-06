import datetime

from database.models import Snippets


def is_snippet_expired(snippet: Snippets):

    if snippet.expires_at < datetime.datetime.utcnow():
        return True

    return False


def save_snippet(snippet: Snippets):
    snippet.expires_at = datetime.datetime.utcnow() + datetime.timedelta(0, snippet.expires_in)
    snippet.save()
    return snippet


def update_snippet(snippet):

    if snippet.likes:
        snippet.likes += 1
    else:
        snippet.likes = 1

    snippet.expires_at = datetime.datetime.utcnow() + datetime.timedelta(0, 30)
    snippet.save()
    return snippet


