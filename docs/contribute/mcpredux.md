---
description: How to set up, run, and test mcpredux, the MCP server that offers the Redux API as tools, and how to point it at a local API.
sources:
  - mcpredux:README.md
  - mcpredux:server.py
  - mcpredux:tests/**
  - mcpredux:integration/**
  - mcpredux:rbs.toml
  - mcpredux:.devcontainer/**
  - mcpredux:pyproject.toml
---

# mcpredux

[mcpredux][repo-mcp] is a server for the [Model Context Protocol](https://modelcontextprotocol.io)
(MCP), the standard way for AI assistants to call tools. It offers the Redux API as thirteen tools,
such as `list_problems`, `solve_problem`, `verify_solution`, and `reduce_problem`. Each tool is a
thin wrapper around an API call. It is written in Python, as a single file, `server.py`.

- **Default branch:** `main`
- **Port:** 8000 in `http` mode
- **Published image:** `ghcr.io/reduxisu/mcpredux`
- **Check:** `build-test / ci`, required
- **Python:** 3.14
- **License:** BSD 2-Clause

The steps every repository shares are in [How to contribute](index.md). This page covers what's
particular to mcpredux.

## Open the devcontainer

The devcontainer has Python 3.14, [uv](https://docs.astral.sh/uv/), rbs, and access to Docker. It
publishes port 8000. It keeps `.venv` in its own volume, and runs `uv sync` for you when it's
created. Open it as described in [Open the devcontainer](index.md#open-the-devcontainer).

On your computer instead, install [uv](https://docs.astral.sh/uv/getting-started/installation/)
and run `uv sync`. uv installs the right Python by itself.

## Run it against a local API

!!! warning "Always pass `--base-url`"

    Without it, mcpredux calls an older address of the live site's API. Start a local API and
    point mcpredux at it, so your work never touches the live site.

Start the API from its published image:

```bash
docker run -d --name redux-api -p 27000:27000 ghcr.io/reduxisu/redux:latest
```

Then run mcpredux in one of its three modes:

| Mode | Command | For |
| --- | --- | --- |
| `stdio` (default) | `uv run server.py --base-url http://localhost:27000` | An MCP client on the same machine, which starts the server itself |
| `http` | `uv run server.py --mode http --base-url http://localhost:27000` | Serving MCP over HTTP at `/mcp`, on `127.0.0.1:8000` by default |
| `proxy` | `uv run server.py --mode proxy --proxy-url <url of an http server>/mcp` | A client that only speaks stdio, connecting to a remote `http` server |

In `http` mode, <http://localhost:8000/health> answers `ok` once the server is up, without calling
the API. Inside the devcontainer, add `--host 0.0.0.0` so the published port can reach it. The API
is then at the address from inside a container: `http://host.docker.internal:27000` with Docker
Desktop, or `http://172.17.0.1:27000` on Linux.

To try it from an MCP client that starts servers itself, give the client a command like this:

```json
{
  "mcpServers": {
    "redux": {
      "command": "uv",
      "args": ["--directory", "/path/to/mcpredux", "run", "server.py",
               "--base-url", "http://localhost:27000"]
    }
  }
}
```

## Test it

```bash
uv run pytest            # the unit tests, in tests/
uv run ruff check .      # lint
uv run black --check .   # formatting; uv run black . fixes it
```

The **unit tests** run the server in the same process against a fake Redux, so they need no API at
all.

The **integration tests** in `integration/` call a running server over HTTP. They read its address
from `RBS_BASE_URL`:

```bash
uv run server.py --mode http --base-url http://localhost:27000 &
RBS_BASE_URL=http://127.0.0.1:8000 uv run pytest integration -v
```

Or let rbs build the image, start it, and test it:

```bash
rbs integration-test
```

Dependencies are pinned in `uv.lock`. After changing `pyproject.toml`, run `uv lock` and commit
both files together. The check fails if the lock is out of date.

## What the check runs

mcpredux's `rbs.toml` uses the `uv` engine. Its check:

- **audits** the locked dependencies for known vulnerabilities;
- **checks formatting** with black and **lints** with ruff;
- runs the **unit tests**. There's no coverage minimum, because `rbs.toml` names no `package` to
  measure;
- **builds the image**, starts it, and runs the **integration tests** against it;
- on a merge to `main`, **publishes** the image.

It also runs once a week on its own, so a newly reported vulnerability in a dependency shows up
even when nothing has changed. [The build system (rbs)](rbs.md) explains each step.

!!! note "Dependency updates waiting, as of 2026-11-07"

    The weekly audit currently finds known vulnerabilities in some dependencies, so the check on
    `main` is red and no new image is published. Several dependency-update pull requests are open.
    Merging them is a good first contribution.

## Add a tool

Every tool is an `async` function in `server.py` with the `@mcp.tool()` decorator. It calls one API
route and returns the result. Its docstring is the description the assistant reads, so write it
for someone who has never seen Redux.

1. Copy a tool that calls a similar route, and give it a docstring. A test fails for any tool
   without one.
2. Add its name to `EXPECTED_TOOLS` in `tests/test_surface.py`, which lists every tool the server
   must offer.
3. Add a row to the table at the top of `tests/test_tools.py`: the tool, the arguments to call it
   with, and the API route and query it should send. The test checks each row against the fake
   Redux.
4. Add the tool to the README's table.
