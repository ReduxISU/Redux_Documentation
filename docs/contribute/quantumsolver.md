---
description: How to set up, run, and test quantumsolver, the Qiskit service that runs Redux's quantum algorithms, and how to add one.
sources:
  - quantumsolver:README.md
  - quantumsolver:.devcontainer/**
  - quantumsolver:src/quantumsolver/**
  - quantumsolver:tests/**
  - quantumsolver:integration/**
  - quantumsolver:rbs.toml
  - quantumsolver:pyproject.toml
  - Redux:Tools/QuantumServerAPI.cs
---

# quantumsolver

[quantumsolver][repo-quantum] runs the quantum algorithms in Redux: Deutsch, Deutsch–Jozsa,
Bernstein–Vazirani, Grover's search, and Shor's factoring. It is a small Python web service
built with Flask and [Qiskit](https://www.ibm.com/quantum/qiskit). Redux calls it whenever someone
picks a quantum solver. Everything else in Redux works without it.

- **Default branch:** `main`
- **Port:** 27100
- **Published image:** `ghcr.io/reduxisu/quantumsolver`
- **Check:** `build-test / ci`, required
- **Python:** 3.13, and the tests also run on 3.12

The steps every repository shares are in [How to contribute](index.md). This page covers what's
particular to quantumsolver.

## Open the devcontainer

The devcontainer has Python 3.13, [uv](https://docs.astral.sh/uv/), rbs, and access to Docker. It
publishes port 27100. It keeps `.venv` in its own volume, so it never mixes with one on your
computer. When it's created, it runs `uv sync --all-groups` for you. Open it as described in
[Open the devcontainer](index.md#open-the-devcontainer).

On your computer instead, install [uv](https://docs.astral.sh/uv/getting-started/installation/)
and run `uv sync`. uv installs the right Python by itself.

## Run it

=== "On your computer"

    ```bash
    uv run flask --app quantumsolver.app run --port 27100
    ```

=== "In the devcontainer"

    Flask listens only inside the container unless you tell it otherwise:

    ```bash
    uv run flask --app quantumsolver.app run --port 27100 --host 0.0.0.0
    ```

Check it at <http://localhost:27100/health>, which answers `{"status": "ok"}`.

To run it the way production does, under gunicorn:

```bash
uv run gunicorn --bind '[::]:27100' quantumsolver.app:app
```

Don't pass `--config gunicorn.conf.py` on your computer. That file also binds a socket path that
only exists on the server.

### Use it from Redux

Redux looks for quantumsolver at `http://localhost:27100` by default. When both run in
containers, put them on one Docker network and tell Redux where it is with
`QuantumSolver__BaseURL`. The [Redux page](redux/index.md#quantum-problems) has the commands.

## The endpoints

Every solver endpoint takes a `POST` with a JSON body.

| Endpoint | Algorithm | Body | Called by Redux's |
| --- | --- | --- | --- |
| `/deutsch-quantum` | Deutsch | `[f(0), f(1)]`, for example `[false, true]` | `DeutschQuantumSolver` |
| `/deutsch-jozsa-quantum` | Deutsch–Jozsa | `{"nbits": 3, "f": [...]}`, with `2^nbits` values | `DeutschJozsaQuantumSolver` |
| `/bernstein-vazirani-quantum` | Bernstein–Vazirani | `{"nbits": 3, "f": [...]}` | `BernsteinVaziraniQuantumSolver` |
| `/sat-quantum` | Grover's search | <code>{"boolexpr": "(x1 &#124; !x2) &amp; (x2 &#124; x3)"}</code> | `SATGroverSolver`, `UnstructuredGroverSolver` |
| `/prime-factorization-quantum` | Shor's | `{"N": 15}`, with N under 512 | `ShorsQuantumSolver` |
| `/health` (`GET`) | | | the readiness check |

Each answer is a JSON object with an `answer` field, and usually the circuit in `qasm`. A solver
gets **25 seconds**, in its own process. After that the answer is `{"answer": "timeout"}`, with no
circuit.

## Test it

```bash
uv run pytest -v                    # the unit tests, in tests/
uv run --python 3.12 pytest -v      # the same, on the other supported Python
uv run ruff check .                 # lint
uv run black --check .              # formatting; uv run black . fixes it
```

The **integration tests** in `integration/` call a running service over HTTP. They read its
address from `RBS_BASE_URL`. To run them against the service you started:

```bash
RBS_BASE_URL=http://localhost:27100 uv run pytest integration -v
```

Or let rbs build the image, start it, and test it:

```bash
rbs integration-test
```

!!! warning "Keep integration tests out of `tests/`"

    `rbs unit-test` runs a plain `pytest`, which only looks in `tests/` (set in
    `pyproject.toml`). An integration test placed in `tests/` would run with no service up, and
    fail.

## What the check runs

quantumsolver's `rbs.toml` uses the `uv` engine. Its check:

- **audits** the locked dependencies for known vulnerabilities;
- **checks formatting** with black and **lints** with ruff;
- runs the **unit tests on Python 3.12 and 3.13**, and requires **85%** coverage on each;
- **builds the image**, starts it, and runs the **integration tests** against it;
- on a merge to `main`, **publishes** the image.

[The build system (rbs)](rbs.md) explains each step. The repository also runs CodeQL code
scanning.

## Add a quantum algorithm

Each algorithm follows the same pattern:

1. **Write the algorithm** as a module in `src/quantumsolver/`, beside `deutsch_quantum.py` and the
   others.
2. **Add an endpoint** in `src/quantumsolver/routes.py`:
    - a *target* function, which runs the algorithm and puts its result on a queue;
    - a `POST` route, which hands the target to `run_with_timeout`.

    Copy an existing pair, such as `deutsch_target` and `/deutsch-quantum`.
3. **Test it** in `tests/test_<name>.py`, beside the others. Add an integration test in
   `integration/test_api.py` for the new endpoint.
4. **Call it from Redux.** A Redux quantum solver posts to the endpoint through
   `QuantumServerAPI.Ask`. It must never return an error text as if it were an answer. See
   [Adding a solver](redux/adding-a-solver.md).
