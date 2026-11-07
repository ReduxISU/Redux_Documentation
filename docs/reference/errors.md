---
description: Every error code the Redux API returns, what causes it, and what to do about it.
sources:
  - Redux:AdditionalControllers/ProblemProvider.cs
  - Redux:Interfaces/ComputeLimits.cs
  - Redux:Interfaces/ComputeJobs.cs
  - Redux:Interfaces/SolverUnavailableException.cs
  - Redux:Interfaces/ParseExceptions.cs
  - Redux:appsettings.json
---

# API errors

This page lists every error the [Redux API](api.md) returns on purpose: its HTTP status, its
`error` code, when it happens, and what to try instead.

!!! info "Verified against `Redux@408f18b` on 2026-11-06"

    Each example body below was produced by a running `ghcr.io/reduxisu/redux:408f18b` image.
    Long `expected` strings are shortened with `…`.

## The shape of an error

Every Redux error is a JSON object with an `error` field. That field is a stable code that a
program can match on. The other fields add context.

```json
{"error": "unknown_solver", "received": "nope"}
```

The newer errors, for limits and unavailable services, follow one fuller shape:

| Field | What it holds |
| --- | --- |
| `error` | The stable code. |
| `message` | One plain sentence saying what happened, fit to show a user. |
| `detail` | The technical reason. |
| `hint` | What to try next. |
| `options` | When there is one, a list of names that would work instead, such as other solvers. |

## Summary

| Code | Status | Means |
| --- | --- | --- |
| [`unknown_solver`](#unknown_solver) | 400 | No solver has that name. |
| [`unknown_visualization`](#unknown_visualization) | 400 | No visualization has that name. |
| [`unknown_reduction`](#unknown_reduction) | 400 | No reduction has that name. |
| [`unknown_interface`](#unknown_interface) | 400 | `info` was asked about a name that doesn't exist. |
| [`unknown_format`](#unknown_format) | 400 | `visualize` was given a `format` other than `list` or `frames`. |
| [`solver_mismatch`](#solver_mismatch) | 400 | The solver and the visualization are for different problems. |
| [`no_verifier`](#no_verifier) | 400 | The problem has only a placeholder verifier. |
| [`no_backward_map`](#no_backward_map) | 400 | The reduction can't map an answer back. |
| [`no_reductions_provided`](#no_reductions_provided) | 400 | `visualizeReduction` got an empty chain. |
| [`instance_parse_error`](#instance_parse_error) | 400 | The instance isn't written the way the problem expects. |
| [`certificate_parse_error`](#certificate_parse_error) | 400 | The certificate isn't written the way the problem expects. |
| [`reduction_input_parse_error`](#reduction_input_parse_error) | 400 | The instance or answer given to a reduction couldn't be read. |
| [`exact_search_limit_exceeded`](#exact_search_limit_exceeded) | 400 | The instance is too large for an exact solver. |
| [`time_limit`](#time_limit) | 422 | The work ran past the time limit and was stopped. |
| [`server_busy`](#server_busy) | 429 | Too many jobs are running right now. |
| [`solver_unavailable`](#solver_unavailable) | 503 | A quantum solver couldn't reach the quantum service. |

## A name that doesn't exist

Names are matched without regard to case. To list the names that do exist, use the
[discovery routes](api.md#discovery).

### `unknown_solver` {#unknown_solver}

`solve?solver=` or `visualize?solver=` named no solver.

```json
{"error": "unknown_solver", "received": "nope"}
```

### `unknown_visualization` {#unknown_visualization}

`visualize?visualization=` named no visualization.

```json
{"error": "unknown_visualization", "received": "nope"}
```

### `unknown_reduction` {#unknown_reduction}

A `reduction=` parameter named no reduction. In `visualizeReduction`, `received` is the first
name in the chain that doesn't exist.

```json
{"error": "unknown_reduction", "received": "nope"}
```

### `unknown_interface` {#unknown_interface}

`info?interface=` named nothing: no problem, solver, verifier, visualization, or reduction.

```json
{"error": "unknown_interface", "received": "nope"}
```

## A request this route can't serve

### `unknown_format` {#unknown_format}

`visualize?format=` was something other than `list` or `frames`.

```json
{"error": "unknown_format", "received": "svg"}
```

### `solver_mismatch` {#solver_mismatch}

`visualize?solver=` named a solver for a different problem than the visualization draws. Pick a
solver from the same problem's list, or leave `solver` out.

```json
{"error": "solver_mismatch", "received": "CliqueBruteForce", "visualization": "Sat3DefaultVisualization"}
```

### `no_verifier` {#no_verifier}

The verifier named is `DummyVerifier`, the placeholder for a problem that has no real verifier
yet. Nothing can check this problem's certificates until someone writes one.

```json
{"error": "no_verifier", "received": "DummyVerifier",
 "detail": "This problem has no verifier yet. DummyVerifier is a placeholder and cannot check certificates."}
```

### `no_backward_map` {#no_backward_map}

`mapSolutionBack` was asked to use a reduction that can only map answers forward. Use
`mapSolution` for that reduction, or a reduction that has a backward map.

```json
{"error": "no_backward_map", "reduction": "KarpReduceGRAPHCOLORING"}
```

### `no_reductions_provided` {#no_reductions_provided}

`visualizeReduction` ended up with no reductions to run. In practice you see a different
answer first: an empty `reduction` is rejected as missing (see
[below](#responses-that-arent-redux-errors)), and a chain with an empty part fails as
[`unknown_reduction`](#unknown_reduction).

```json
{"error": "no_reductions_provided"}
```

## Input that can't be read

These three errors share one shape. `expected` is the format the problem accepts, copied from
its `instanceFormat` or `certificateFormat`. `received` is what you sent, and `detail` says
where reading failed.

### `instance_parse_error` {#instance_parse_error}

The instance isn't written the way the problem expects. Compare it with `expected`, or with the
problem's `defaultInstance` from `info`.

```json
{"error": "instance_parse_error", "problem": "3SAT",
 "expected": "Boolean formula in 3-CNF. Clauses joined by '&', literals within a clause joined by '|', … Example: (x1 | x2 | x3) & (!x1 | !x2 | !x3) & …",
 "received": "(x1 | x2",
 "detail": "expected '|' or ')', found end of input (at column 9)"}
```

### `certificate_parse_error` {#certificate_parse_error}

The certificate given to `verify` isn't written the way the problem expects.

```json
{"error": "certificate_parse_error", "problem": "3SAT",
 "expected": "Comma-separated variable:Boolean pairs, optionally wrapped in parentheses. … Example: (x1:True,x2:False,x3:True)",
 "received": "banana",
 "detail": "assignment 'banana' is missing a ':' or '=' separator"}
```

### `reduction_input_parse_error` {#reduction_input_parse_error}

The instance or answer given to a reduction route couldn't be read. It also names the
`reduction`. `problem` and `expected` describe whichever problem the input belongs to. For
`mapSolutionBack`, that is the **target** problem, because `solution` is the target's answer.

```json
{"error": "reduction_input_parse_error", "reduction": "Sipser's Clique Reduction",
 "problem": "Clique", "expected": "Format: {K | K is set} Example: {2,3,4,5}",
 "received": "{x1_0,!x2_1,x1_2}", "detail": "'!x2_1' is not a node of the problem"}
```

## Limits

### `exact_search_limit_exceeded` {#exact_search_limit_exceeded}

The instance has more variables than an exact search is allowed to try. Today only Weighted
Max-SAT has this cap, at 20 variables. Use a smaller instance or an approximate solver.

```json
{"error": "exact_search_limit_exceeded", "variableCount": 21, "maxVariables": 20,
 "detail": "Weighted Max-SAT exact search supports at most 20 variables; received 21."}
```

### `time_limit` {#time_limit}

**HTTP 422.** The work ran past the time limit, 10 seconds by default, and was stopped. There is
no answer. The `hint` and `options` suggest faster solvers for the same problem when there are
any.

```json
{"error": "time_limit",
 "message": "The solve ran past the 1-second time limit, so it was stopped.",
 "detail": "The solver checked the time limit and stopped before it finished; there is no answer.",
 "limitSeconds": 1, "solver": "CliqueBruteForce", "problem": "Clique",
 "options": ["CarraghanPardalos", "ChibaNishizeki"],
 "hint": "Try a smaller instance, or a faster solver for this problem: CarraghanPardalos, ChibaNishizeki."}
```

(This example comes from a server configured with a 1-second limit.)

Two details:

- When `detail` says *"The server stopped waiting at the time limit"*, the work didn't stop on its
  own and may keep running on the server for a while. It still counts toward
  [`server_busy`](#server_busy) until it finishes.
- `visualize` is different. A solve stopped by the time limit is still drawn from the steps it
  recorded, and the last frame says it was stopped. You get `time_limit` from `visualize` only
  when the drawing itself doesn't stop.

Whoever runs the server sets the limit with `ComputeLimits:TimeLimitSeconds`, or the environment
variable `ComputeLimits__TimeLimitSeconds`. Zero turns the limit off.

### `server_busy` {#server_busy}

**HTTP 429.** Every slot for compute jobs is in use, so this request wasn't started. The
response has a `Retry-After: 5` header. Wait that long and send the same request again.

```json
{"error": "server_busy",
 "message": "The server is busy with other jobs right now, so this one wasn't started.",
 "detail": "At most 1 compute jobs can run at once, and all of them are in use.",
 "maxConcurrentJobs": 1, "retryAfterSeconds": 5,
 "hint": "Wait about 5 seconds and try again."}
```

The cap is the server's processor count, with a minimum of 2. Whoever runs the server can change
it with `ComputeLimits:MaxConcurrentJobs`, or `ComputeLimits__MaxConcurrentJobs`. Zero or less
turns the cap off.

## Services

### `solver_unavailable` {#solver_unavailable}

**HTTP 503.** A quantum solver couldn't get an answer from the quantum service, which is
quantumsolver. `options` lists the problem's other solvers, and `hint` names the ones that run
without the quantum service.

```json
{"error": "solver_unavailable",
 "message": "Deutsch's Algorithm couldn't get an answer from the quantum service, so Deutsch wasn't solved.",
 "solver": "DeutschQuantumSolver", "problem": "Deutsch",
 "detail": "The quantum service did not give an answer: Failed to POST to http://localhost:27100/deutsch-quantum: Connection refused (localhost:27100)",
 "hint": "DeutschClassicalSolver (Deutsch Classical) runs without the quantum service; or try again later.",
 "options": ["DeutschClassicalSolver"]}
```

Quantum *visualizations* don't return this error. When the service can't be reached they answer
HTTP 200 with an empty `qasm` circuit.

## Responses that aren't Redux errors

Some failures never reach Redux's own error handling. They don't have an `error` field.

| You get | Why |
| --- | --- |
| **400** with `"title": "One or more validation errors occurred."` | A required query parameter is missing or empty, or the body isn't a JSON string, for example an instance sent without its surrounding quotes. This is ASP.NET's standard validation response. |
| **500** with no body | An unknown name in `verify?verifier=` or `problemInstance?problem=`. These two routes don't check the name first. Check the spelling against the [discovery routes](api.md#discovery). |
