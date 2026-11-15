---
description: How to build and test SPADE, the library Redux uses to read problem instances, how its grammar is changed, and how a release reaches Redux.
sources:
  - SPADE:README.md
  - SPADE:Documentation/**
  - SPADE:DiscreteParser.csproj
  - SPADE:SPADE.slnx
  - SPADE:StringParser.cs
  - SPADE:UtilCollection.cs
  - SPADE:LICENSE.txt
  - SPADE:grammar/**
  - SPADE:tests/**
  - SPADE:rbs.toml
  - SPADE:.github/workflows/**
  - SPADE:.devcontainer/**
  - Redux:API.csproj
---

# SPADE

[SPADE][repo-spade] is the C# library Redux uses to read problem instances. You describe the shape
of an instance with a short **definition string**, such as `{(N,E) | N is set, E subset N cross
N}`. SPADE then parses an **instance string**, such as `({A,B,C},{(A,B),(B,C)})`, checks it
against that shape, and hands back its parts. Redux installs it as a NuGet package. Russell
Phillips first wrote it as an undergraduate at Idaho State University.

- **Default branch:** `main`
- **Package:** [`SPADE` on NuGet](https://www.nuget.org/packages/SPADE)
- **Check:** `build-test / ci`, which **reports only** for now
- **License:** MIT, in `LICENSE.txt`

The steps every repository shares are in [How to contribute](index.md). This page covers what's
particular to SPADE.

## Use it

```bash
dotnet add package SPADE
```

```csharp
using SPADE;

StringParser graph = new("{(N,E) | N is set, E subset N cross N}");
graph.parse("({A,B,C,D},{(A,B),(B,C),(C,D),(D,A),(A,C)})");

Console.WriteLine(graph["N"]);
foreach (UtilCollection edge in graph["E"]) {
    Console.WriteLine(edge);
}
```

Each key in the definition string, here `N` and `E`, becomes a part you can read back. The
library's own [documentation](https://github.com/ReduxISU/SPADE/blob/HEAD/Documentation/index.md)
describes definition strings, instance strings, and the `UtilCollection` type.

## Open the devcontainer

The devcontainer has the .NET 10 SDK and rbs. It doesn't publish a port, because SPADE is a library
with nothing to run. Open it as described in
[Open the devcontainer](index.md#open-the-devcontainer).

On your computer instead, install the [.NET 10 SDK](https://dotnet.microsoft.com/en-us/download).
The library targets .NET 6 and the tests target .NET 10, and SDK 10 builds both.

!!! note "Linux: your clone changes owner"

    With Docker Engine on Linux, including WSL2, the files in your clone belong to user ID 1655
    after the container starts. The image already has a user with ID 1000, so the container's
    `vscode` user can't take your ID, and the container then gives the workspace to `vscode`.
    Inside the container everything works. On your computer, `git` refuses the clone with
    "dubious ownership" until you run `sudo chown -R "$USER:$USER" .` in it. Codespaces don't
    mount a folder from your computer, so they aren't affected.

## Build and test

```bash
dotnet build SPADE.slnx -c Release
dotnet test SPADE.slnx -c Release
dotnet format SPADE.slnx
```

The tests are in `tests/SPADE.Tests/`, and use xUnit. There are 34 as of 2026-11-07.

## Change the grammar

The grammar for definition strings is `grammar/coll.g4`, written for
[ANTLR](https://www.antlr.org/). The parser code next to it is generated from that file, so
don't edit it by hand.

The devcontainer doesn't include ANTLR. Install the `antlr4-tools` Python package, with
`uv tool install antlr4-tools` or `pip install antlr4-tools`. On first use it downloads a Java
runtime and the ANTLR jar. Pass `-v 4.13.2`, the version that generated the committed files, so
your diff shows only your change. Then, from inside `grammar/`:

```bash
antlr4-parse -v 4.13.2 coll.g4 start -gui    # try a rule interactively
antlr4 -v 4.13.2 coll.g4                     # regenerate the parser after editing coll.g4
```

Without `-v`, `antlr4` looks up the newest release and, as of 2026-11-07, fails with
`FileNotFoundError` before it generates anything.

Commit the regenerated files together with your change to `coll.g4`.

## What the check runs

SPADE's `rbs.toml` uses the `dotnet` engine on `SPADE.slnx`. It audits, checks formatting, builds,
and runs the tests with a **70%** coverage minimum. There is no image to build or publish.

!!! warning "The check doesn't fail yet"

    SPADE runs rbs with `soft: true`, so the check reports problems without failing. Its coverage
    is about 14% as of 2026-11-07, well below the 70% minimum. Read the report on your pull request
    even when the check is green, and add tests for the code you change.

You can run the same pipeline in the devcontainer with `rbs ci`. Expect it to end with the
coverage failure and exit 1, with `push` blocked: that's the report the check posts.

A second workflow, `ci.yml`, also builds the library and runs the tests.

## Release a new version

Redux uses SPADE **only through the published package**, at the version named in Redux's
`API.csproj`. A change merged here reaches Redux only after both of these:

1. **A release.** Raise `<Version>` in `DiscreteParser.csproj` in a pull request, and merge it. Then
   push a tag that matches it exactly, such as `v0.1.3`. The tag starts `publish.yml`, which checks
   that the tag and the version agree, runs the tests, packs the library, and publishes the
   package to NuGet. It signs in with NuGet trusted publishing, so no API key is stored in the
   repository.
2. **An update in Redux.** A pull request in Redux raises SPADE's version in `API.csproj`.

!!! note "Unreleased changes"

    As of 2026-11-07, the only published version is 0.1.2, from May 2025. No release tag has
    been pushed since `publish.yml` arrived, so it has never run. Everything merged since 0.1.2 is
    in `main` but not in Redux. Bear that in mind when SPADE's documentation describes behaviour
    Redux doesn't show.
