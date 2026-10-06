# Stellar Coding Challenge

## Summary

Write an API web server that accepts a snippet of text and makes that snippet
available at a URL. Each snippet should be available as text at a URL until it
expires. A snippet's expiry should be extended by 30 seconds each time it is accessed.

The request to store the snippet should accept this information:

| Name       | Description                                      |
|------------|--------------------------------------------------|
| name       | Name of the snippet                              |
| expires_in | Seconds from now until the snippet should expire |
| snippet    | Contents of the snippet                          |

The request to store the snippet should be replied to with a response that
includes the URL where the snippet can be read.

Snippets can be stored in memory, and do not need to be editable after storing.
The solution needs only to be an API, not a graphical or website user
interface.

Snippets should be retrievable by name.

## What we're looking for

* An actual HTTP web server that runs and can be accessed through a URL
* A clean, minimalistic implementation. Focus on the core functionality, and pay extra attention to API the service should serve
* Appropriate use of web frameworks and open-source libraries as necessary. Think of this as building an MVP
* Too little time? Your prioritization skills are also being evaluated
* Readable and clear code, so that everyone and anyone can understand it

## What we're not looking for

* Don't write your own HTTP implementation. You won't get extra points for it, and this will probably take time that could be spent elsewhere
* This is a simple problem. If your solution is complex, take a step back
* Do not reinvent the wheel. Make use of all the tools you know and like, as well as the knowledge you've built throughout your career

## Test Cases

We expect you to implement this API exactly. Please ensure your solution handles these test cases correctly.

```sh

curl -X POST -H "Content-Type: application/json" -d '{"name":"recipe", "expires_in": 30, "snippet":"1 apple"}' https://example.com/snippets
# response 201 Created
{
  "url": "https://example.com/snippets/recipe",
  "name": "recipe",
  "expires_at": "2020-02-22T20:02:02Z",
  "snippet": "1 apple"
}

curl https://example.com/snippets/recipe
# response 200 OK
{
  "url": "https://example.com/snippets/recipe",
  "name": "recipe",
  "expires_at": "2020-02-22T20:02:32Z",
  "snippet": "1 apple"
}

# wait 60 seconds

curl https://example.com/snippets/recipe
# response 404 Not Found

```

## Extension

Pick one feature to implement on top of the above. Pick only one.

1. Store snippets on disk in files.
2. Allow editing snippets using an optional password set at the time they are stored. Editing extends expiration by 30 seconds if a new expiration is not specified.
3. Add a "like" API endpoint that increases a counter for a snippet. Liking extends expiration by 30 seconds.

## Extension Test Cases

```sh

# 1. store on disk

# The API doesn't change silly!

# 2. editing with password

# create the snippet
curl -X POST -H "Content-Type: application/json" -d '{"name":"recipe", "expires_in":30, "snippet":"1 apple", "password":"1234"}' https://example.com/snippets
# response 201 Created
{
  "url": "https://example.com/snippets/recipe",
  "name": "recipe",
  "expires_at": "2020-02-22T20:02:02Z",
  "snippet": "1 apple",
  "password": "1234"
}

# edit the snippet
curl -X PUT -H "Content-Type: application/json" -d '{"password":"1234", "snippet":"40 grapes"}' https://example.com/snippets/recipe
# response 200 OK
{
  "url": "https://example.com/snippets/recipe",
  "name": "recipe",
  "expires_at": "2020-02-22T20:02:32Z",
  "snippet": "40 grapes",
  "password": "1234"
}

# 3. like endpoint
curl -X POST https://example.com/snippets/recipe/like
# response 200 OK
{
  "url": "https://example.com/snippets/recipe",
  "name": "recipe",
  "expires_at": "2020-02-22T20:02:32Z",
  "snippet": "1 apple",
  "likes": 1
}

curl https://example.com/snippets/recipe
# response 200 OK
{
  "url": "https://example.com/snippets/recipe",
  "name": "recipe",
  "expires_at": "2020-02-22T20:03:02Z",
  "snippet": "1 apple",
  "likes": 1
}
```

## Instructions

Aim to spend about 2 hours on an implementation.

The code should be comparable to code you’d put in front of others for code
review and put in production. It should address production concerns, but the
number of concerns it addresses may be limited given the time constraint.
Include what you can. If you’re short on time, aim to make something unpolished
that works rather than something polished but incomplete.  Feel free to access
online resources, but you must complete the challenge without help from anyone
else.

Include a README that explains your assumptions, design decisions, production
concerns addressed, why you've chosen the technologies, error handling
approach, and any other discussion about the solution to demonstrate your
experience building production systems.

Use the repl.it online IDE to code your solution. Go to [repl.it/languages] to
start. Once your application exposes a port (e.g. 3000, 4567, 8080) your
application will automatically be given a URL where you can access your API.
You may also code your solution offline on your own computer, but please upload
your solution to repl.it and ensure it runs successfully before sending in the
solution.

Use the language you are most proficient with to complete the solution, but if
you are proficient in Go we’d love to see what your solution looks like in it
as we use Go heavily.

[repl.it/languages]: https://repl.it/languages
