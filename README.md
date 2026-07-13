All individual readme inside individual directories

## Build system

This repo uses [Bazel](https://bazel.build) (via [Bazelisk](https://github.com/bazelbuild/bazelisk)) as its build system. Install Bazelisk once and it auto-downloads the right Bazel version pinned in `.bazelversion`.

```
brew install bazelisk
```

## parse-git

A Go tool that parses `git log` output into structured commits.

```bash
# build
bazel build //parse-git:parse-git

# run
bazel run //parse-git:parse-git

# run tests
bazel test //parse-git/...

# build + test everything in parse-git
bazel build //parse-git/... && bazel test //parse-git/...
```

After any change to Go source files, regenerate BUILD files with Gazelle:

```bash
bazel run //:gazelle
```
