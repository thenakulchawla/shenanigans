class InternalServerError(Exception):
    pass


class SchemaValidationError(Exception):
    pass


class UpdatingSnippetError(Exception):
    pass


class SnippetDoesNotExistError(Exception):
    pass


errors = {
    "InternalServerError": {
        "message": "Something went wrong",
        "status": 500
    },
    "SchemaValidationError": {
        "message": "Request is missing required fields",
        "status": 400
    },
    "UpdatingSnippetError": {
        "message": "Updating snippet added by other is forbidden",
        "status": 403
    },
    "SnippetDoesNotExistError": {
        "message": "Snippet with given name doesn't exists",
        "status": 404
    },
}
