from flask import request, Response
from database.models import Snippets
from flask_restful import Resource
from mongoengine.errors import  DoesNotExist, InvalidQueryError
from resources.errors import SnippetDoesNotExistError, InternalServerError, SchemaValidationError, UpdatingSnippetError
from services.snippet_service import is_snippet_expired, save_snippet, update_snippet


class SnippetApi(Resource):

    def get(self, name):
        try:
            snippets = Snippets.objects().get(name=name)
            is_expired = is_snippet_expired(snippets)
            if is_expired:
                raise DoesNotExist
            else:
                return Response(snippets.to_json(), mimetype="application/json", status=200)
        except DoesNotExist:
            return '', 404
        except Exception:
            raise InternalServerError


class SnippetsApi(Resource):

    def post(self):
        try:
            body = request.get_json()
            snippet = Snippets(**body)
            snippet = save_snippet(snippet)
            return Response(snippet.to_json(), mimetype="application/json", status=200)
        except InvalidQueryError:
            raise SchemaValidationError
        except DoesNotExist:
            raise UpdatingSnippetError
        except Exception:
            raise InternalServerError


class LikeApi(Resource):

    def post(self, name):
        try:
            snippet = Snippets.objects.get(name=name)
            snippet = update_snippet(snippet)
            return Response(snippet.to_json(), mimetype="application/json", status=200)
        except InvalidQueryError:
            raise SchemaValidationError
        except DoesNotExist:
            return '', 404
        except Exception:
            raise InternalServerError