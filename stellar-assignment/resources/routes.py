from resources.snippets import SnippetApi, SnippetsApi, LikeApi


def initialize_routes(api):
    api.add_resource(SnippetsApi, '/api/snippets')
    api.add_resource(SnippetApi, '/api/snippets/<name>')
    api.add_resource(LikeApi, '/api/snippets/<name>/like')

