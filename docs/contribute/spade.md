---
description: How to build and test SPADE, the library Redux uses to read problem instances, how its grammar is changed, and how a release reaches Redux.
sources:
  - SPADE:README.md
  - SPADE:Documentation/**
  - SPADE:DiscreteParser.csproj
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

## Build and test

```bash
dotnet build SPADE.slnx -c Release
dotnet test SPADE.slnx -c Release
dotnet format SPADE.slnx
```

The tests are in `tests/SPADE.Tests/`, and use xUnit.

## Change the grammar

The grammar for definition strings is `grammar/coll.g4`, written for
[ANTLR](https://www.antlr.org/). The parser code next to it is generated from that file, so
don't edit it by hand. With ANTLR installed, from inside `grammar/`:

```bash
antlr4-parse coll.g4 start -gui    # try a rule interactively
antlr4 coll.g4                     # regenerate the parser after editing coll.g4
```

Commit the regenerated files together with your change to `coll.g4`.

## What the check runs

SPADE's `rbs.toml` uses the `dotnet` engine on `SPADE.slnx`. It audits, checks formatting, builds,
and runs the tests with a **70%** coverage minimum. There is no image to build or publish.

!!! warning "The check doesn't fail yet"

    SPADE runs rbs with `soft: true`, so the check reports problems without failing. Its coverage
    is currently well below the 70% minimum. Read the report on your pull request even when the
    check is green, and add tests for the code you change.

A second workflow, `ci.yml`, also builds the library and runs the tests.

## Release a new version

Redux uses SPADE **only through the published package**, at the version named in Redux's
`API.csproj`. A change merged here reaches Redux only after both of these:

1. **A release.** Raise `<Version>` in `DiscreteParser.csproj` in a pull request, and merge it. Then
   push a tag that matches it exactly, such as `v0.1.3`. The tag starts `publish.yml`, which checks
   that the tag and the version agree, runs the tests, and publishes the package to NuGet.
2. **An update in Redux.** A pull request in Redux raises SPADE's version in `API.csproj`.

!!! note "Unreleased changes"

    As of 2026-11-07, the only published version is 0.1.2, from 2025. Everything merged since
    then is in `main` but not in Redux. Bear that in mind when SPADE's documentation describes
    behaviour Redux doesn't show.
