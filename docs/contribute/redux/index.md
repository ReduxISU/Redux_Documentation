---
description: How to set up, run, and test the Redux API, what its build-test / ci check runs, and which guide to read for each task.
sources:
  - Redux:Documentation/guides/setup.md
  - Redux:Documentation/guides/README.md
  - Redux:.devcontainer/**
  - Redux:Properties/launchSettings.json
  - Redux:Dockerfile
  - Redux:rbs.toml
  - Redux:.github/workflows/**
  - Redux:appsettings.json
---

# Redux

[Redux][repo-redux] is the API, the part of the project that holds every problem, solver,
verifier, reduction, and visualization. It is written in C# on .NET 10 and listens on port
27000. The website and the other tools call it. Most contributions go here.

- **Default branch:** `CSharpAPI`
- **Port:** 27000
- **Published image:** `ghcr.io/reduxisu/redux`
- **Check:** `build-test / ci`, required

The steps every repository shares, from branching to merging, are in
[How to contribute](../index.md). This page covers what is particular to Redux.

## Which guide do I need?

| I want to... | Read |
| --- | --- |
| Understand the folders and the five interfaces | [How the code works](how-the-code-works.md) |
| Check my work, or fix a red check on my pull request | [Building and testing](building-and-testing.md) |
| Fix an error message | [Troubleshooting](troubleshooting.md) |
| Add a new problem | [Adding a problem](https://github.com/ReduxISU/Redux/blob/HEAD/Documentation/guides/adding-a-problem.md) |
| Add a way to solve a problem (a solver) | [Adding a solver](https://github.com/ReduxISU/Redux/blob/HEAD/Documentation/guides/adding-a-solver.md) |
| Add a way to check an answer (a verifier) | [Adding a verifier](https://github.com/ReduxISU/Redux/blob/HEAD/Documentation/guides/adding-a-verifier.md) |
| Add a reduction from one problem to another | [Adding a reduction](https://github.com/ReduxISU/Redux/blob/HEAD/Documentation/guides/adding-a-reduction.md) |
| Add a visualization (a picture of a problem) | [Adding a visualization](https://github.com/ReduxISU/Redux/blob/HEAD/Documentation/guides/adding-a-visualization.md) |

A brand-new problem usually needs all of these, in this order: the problem, then a verifier, a
solver, and a visualization, then reductions that connect it to other problems. Read
[How the code works](how-the-code-works.md) first, and the task guides will be easier to follow.

## Set up

=== "In the devcontainer"

    The devcontainer has the .NET 10 SDK and rbs, and it runs the same build as the check on
    GitHub. Open it as described in [Open the devcontainer](../index.md#open-the-devcontainer).
    When it's created, it runs `dotnet restore Redux.slnx` for you and publishes port 27000.

=== "On your computer"

    | Tool | Why | Check that it works |
    | --- | --- | --- |
    | [.NET 10 SDK](https://dotnet.microsoft.com/en-us/download) | Builds and runs Redux | `dotnet --version` prints something starting with `10.` |
    | [Git](https://git-scm.com/downloads) | Gets the code and sends your changes back | `git --version` prints a version number |
    | An editor: [VS Code](https://code.visualstudio.com/) with the C# extension, [Visual Studio](https://visualstudio.microsoft.com/), or [JetBrains Rider](https://www.jetbrains.com/rider/) | Where you write code | It opens `Redux.slnx` with no red errors |
    | [Docker](https://docs.docker.com/get-docker/) (optional) | Only for the Docker steps below | `docker --version` |

    Run `dotnet --list-sdks`. You should see a line starting with `10.`. Older SDKs can stay
    installed alongside it.

Clone the repository and branch from `CSharpAPI`, as in
[Clone and make a branch](../index.md#clone-and-make-a-branch).

## Run it

From the repository root, the folder with `API.csproj` and `Redux.slnx`:

```bash
dotnet run
```

The first run downloads packages and builds, so it can take a minute. Success looks like this:

```text
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: http://0.0.0.0:27000
info: Microsoft.Hosting.Lifetime[0]
      Application started. Press Ctrl+C to shut down.
```

Then check it:

| Address | What you should see |
| --- | --- |
| <http://localhost:27000/health> | The word `ok` |
| <http://localhost:27000/swagger/index.html> | The Swagger page, listing every API call |
| <http://localhost:27000/Navigation/Reductions> | A long block of JSON: every reduction, grouped by the problem it starts from |

In Swagger, open a call, select **Try it out**, then **Execute**. Every call has example values
filled in. Press `Ctrl+C` in the terminal to stop the API.

To have the API restart each time you save a file, use `dotnet watch` instead:

```bash
dotnet watch --project API.csproj run
```

!!! note "Name the solution for build and test"

    A bare `dotnet run` works, because it only looks for a project file. `dotnet build` and
    `dotnet test` fail with `error MSB1011` unless you name `Redux.slnx`, because the root folder
    holds both `API.csproj` and `Redux.slnx`.

### Run the image instead

To check the container itself, build and run the same image that is published:

```bash
docker build -t redux-local .
docker run -it --rm -p 27000:27000 redux-local
```

You don't need to build it to use the API from another project. The published image works:

```bash
docker run -d --name redux-api -p 27000:27000 ghcr.io/reduxisu/redux:latest
```

### Quantum problems

Only the quantum solvers need the quantum service. Without it, those solvers answer
[`solver_unavailable`](../../reference/errors.md#solver_unavailable), and everything else works.
To run it alongside Redux natively:

```bash
docker run -d --name quantum -p 27100:27100 ghcr.io/reduxisu/quantumsolver:latest
```

Redux looks for it at `http://localhost:27100` by default. When Redux runs in a container too,
put both on one Docker network and tell Redux where it is:

```bash
docker network create redux-net
docker run -d --name quantum --network redux-net ghcr.io/reduxisu/quantumsolver:latest
docker run -d --name redux-api --network redux-net -p 27000:27000 \
  -e QuantumSolver__BaseURL=http://quantum:27100 ghcr.io/reduxisu/redux:latest
```

## Test it

[Building and testing](building-and-testing.md) has the full routine and the tests each kind of
change needs. The short version:

```bash
dotnet format Redux.slnx
dotnet build Redux.slnx -c Release
dotnet test Redux.slnx -c Release --filter "Category!=Performance"
```

Or run everything the check runs, inside the devcontainer:

```bash
rbs ci
```

## What the check runs

Redux's `rbs.toml` uses the `dotnet` engine on `Redux.slnx`. Its check:

- **audits** the NuGet packages for known vulnerabilities;
- **checks formatting** and **builds** in Release. Warnings count as errors, so the build is also
  the lint step;
- runs **every unit test**, including the performance tests, and requires **80%** coverage;
- **builds the image**, after filling in contributor counts (if that step fails, the build only
  warns);
- **starts the image** and runs the integration tests in `integration/` against it;
- on a merge to `CSharpAPI`, **publishes** the image.

[The build system (rbs)](../rbs.md) explains each step. Redux also runs CodeQL code scanning on
pull requests, and a weekly job that refreshes contributor information.

## Things that trip people up

- **Name `Redux.slnx`** in every `dotnet build` and `dotnet test` command.
- **Formatting is checked only in a Release build.** A Debug build can pass on your computer and
  still fail the check. Build with `-c Release` before you push.
- **Warnings are errors.** An unused variable fails the build.
- **Class names must be unique, ignoring case.** Redux finds every class by its lowercase name,
  and two classes with the same name stop the API from starting.
- **The class name is the ID callers use.** Renaming a class changes the API.
- **Starter files:** `GET /ProblemTemplate` and its `solver`, `verifier`, `reduction`, and
  `visualization` variants hand you a zip of files to fill in. Find them in Swagger under
  "Problem Template".
