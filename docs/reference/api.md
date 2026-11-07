---
description: Every route of the Redux REST API, with its parameters, request body, and response.
sources:
  - Redux:AdditionalControllers/**
  - Redux:ProblemTemplate/ProblemTemplate.cs
  - Redux:Interfaces/Tools/ProblemInstanceGenerators.cs
  - Redux:Tools/ApiParameters.cs
  - Redux:Program.cs
---

# Redux API

This page lists every route of the Redux API: what it takes and what it returns. For trying a
call interactively, use [Swagger][redux-swagger]. For what an error response means, see
[API errors](errors.md).

!!! info "Verified against `Redux@408f18b` on 2026-11-06"

    Every example below was run against the `ghcr.io/reduxisu/redux:408f18b` image. The live site
    can run an older build, so a route added recently may not be there yet. To see exactly what the
    live API offers, open [Swagger][redux-swagger].

## Base URLs

| Where | Base URL |
| --- | --- |
| The live site | `https://redux.isu.edu/api/redux/` |
| Your computer, running the Redux image or `dotnet run` | `http://localhost:27000/` |

Swagger is at `<base>/swagger/index.html` on both.

## How requests work

- **Names are class names, and case doesn't matter.** `SAT3Verifier`, `sat3verifier`, and
  `SAT3VERIFIER` are the same verifier. A problem is named by its class, such as `SAT3` or
  `CLIQUE`, not by its display name ("3SAT", "Clique").
- **A `POST` body is a JSON string.** Send the instance wrapped in double quotes, with
  `Content-Type: application/json`. The one exception is `verify`, which takes an object.
- **Answers are JSON strings too.** A solve returns `"(x1:True,x2:False,x3:False)"`, quotes included.
- **Compute routes share limits.** Every route marked *compute* below stops at a time limit (10
  seconds by default) and counts against a cap on jobs running at once. See
  [`time_limit`](errors.md#time_limit) and [`server_busy`](errors.md#server_busy).

To find the names you can use, ask the API: the [discovery routes](#discovery) list every
problem, solver, verifier, visualization, and reduction.

## A first call

These examples use the live site. Swap in `http://localhost:27000` to use your own copy.

=== "Solve"

    ```bash
    curl -X POST 'https://redux.isu.edu/api/redux/ProblemProvider/solve?solver=Sat3BacktrackingSolver' \
      -H 'Content-Type: application/json' \
      -d '"(x1 | !x2 | x3) & (!x1 | x3 | x1) & (x2 | !x3 | x1)"'
    ```

    ```json
    "(x1:True,x2:False,x3:False)"
    ```

=== "Verify"

    ```bash
    curl -X POST 'https://redux.isu.edu/api/redux/ProblemProvider/verify?verifier=SAT3Verifier' \
      -H 'Content-Type: application/json' \
      -d '{"Certificate": "(x1:True,x2:False,x3:False)",
           "ProblemInstance": "(x1 | !x2 | x3) & (!x1 | x3 | x1) & (x2 | !x3 | x1)"}'
    ```

    ```json
    "True"
    ```

=== "Reduce"

    ```bash
    curl -X POST 'https://redux.isu.edu/api/redux/ProblemProvider/reduce?reduction=SipserReduceToCliqueStandard' \
      -H 'Content-Type: application/json' \
      -d '"(x1 | !x2 | x3) & (!x1 | x3 | x1) & (x2 | !x3 | x1)"'
    ```

    The response is the whole reduction. The new CLIQUE instance is in `reductionTo.instance`:

    ```text
    (({x1_0,!x2_0,x3_0,!x1_1,x3_1,x1_1,x2_2,!x3_2,x1_2},{{x1_0,x3_1},{x1_0,x1_1}, ...
    ```

## Problem provider

These routes do the work: parse an instance, then solve, check, reduce, or draw it. Every path
starts with `/ProblemProvider/`. The query parameters are names, and the instance goes in the
body.

| Route | Query | Body | Returns |
| --- | --- | --- | --- |
| `GET info` | `interface`, `includePictures`¹ | none | The metadata of any problem, solver, verifier, visualization, or reduction. A problem's info includes `defaultInstance`, `instanceFormat`, `certificateFormat`, and its default solver, verifier, and visualization. |
| `POST problemInstance` | `problem`, `includePictures`¹ | instance | The problem's metadata with the instance parsed into its parts. Use it to check that an instance is well formed. |
| `POST solve` *(compute)* | `solver` | instance | The solver's answer, as a certificate string. |
| `POST verify` *(compute)* | `verifier` | `{"Certificate": "…", "ProblemInstance": "…"}` | `"True"` or `"False"`. |
| `POST reduce` *(compute)* | `reduction`, `includePictures`¹ | source instance | The reduction: `reductionFrom`, `reductionTo` (with the new `instance`), `gadgets`, `cost`, `reductionType`, `complexityBucket`. |
| `POST mapSolution` *(compute)* | `reduction`, `solution` (a source certificate) | source instance | The matching certificate for the target problem. |
| `POST mapSolutionBack` *(compute)* | `reduction`, `solution` (a target certificate), `steps` | source instance | The matching certificate for the source problem. With `steps=true`, `{"answer": …, "steps": […]}`. Only some reductions can do this; the rest answer [`no_backward_map`](errors.md#no_backward_map). |
| `POST gadgets` *(compute)* | `reduction` | source instance | The list of gadgets: which parts of the source became which parts of the target. |
| `POST visualize` *(compute)* | `visualization`, `solver`², `format`³ | instance | The pictures of the instance, the solver's steps, and the solution. |
| `POST visualizeReduction` *(compute)* | `reduction` (one, or several joined by `-`), `solution` (a source certificate), `includePictures`¹ | source instance | The pictures of the final target instance with the mapped solution. |

¹ `includePictures=true` returns the data for the redesigned visualizations. The default,
`false`, is what the Redux website reads.

² `solver` picks whose steps and answer are drawn. It must solve the same problem as the
visualization, or the API answers [`solver_mismatch`](errors.md#solver_mismatch). Leave it out to
use the visualization's own solver.

³ `format=list`, the default, returns a list: `[initial, ...steps, solved]`. `format=frames`
returns `{"type": …, "payload": …, "frames": […]}`, where `payload` is the initial picture.
For the `Graph` picture type, each frame is `{event, caption, focus, nodes, edges, phantoms}`.
A solve stopped by the time limit is still drawn, from the steps it recorded, rather than
returned as an error.

## Discovery

These routes list what exists. Every path starts with `/Navigation/`. They take no body and run
no computation.

| Route | Query | Returns |
| --- | --- | --- |
| `GET ALL_ProblemsRefactor` | none | Every problem's class name. |
| `GET NPC_ProblemsRefactor`, `P_ProblemsRefactor`, `NPHard_ProblemsRefactor` | none | The problems in one complexity class. Problems in other classes (NP, EQP, BQP) are listed only by `ALL_ProblemsRefactor`. |
| `GET Problem_SolversRefactor` | `chosenProblem` | The problem's solvers. |
| `GET Problem_VerifiersRefactor` | `chosenProblem` | The problem's verifiers. |
| `GET Problem_VisualizationsRefactor` | `chosenProblem`, `includePictures`¹ | The problem's visualizations. |
| `GET Batch/allProblems` | none | Every problem's class name. |
| `GET Batch/allSolvers`, `allVerifiers` | none | A map from each problem to its solvers or verifiers. |
| `GET Batch/allVisualizations` | `includePictures`¹ | A map from each problem to its visualizations. |
| `GET Batch/allInfo` | `includePictures`¹ | A map from every class name to its `info` object. |
| `GET Batch/allVisualizationTypes` | `includePictures`¹ | A map from each visualization to its picture type. |
| `GET Reductions` | `source`, `target` (both optional) | The reduction graph: source problem → target problem → the reductions between them. Each one carries `className`, `reductionName`, `endpoint`, `inputType`, `outputType`, `cost`, `reductionType`, and `complexityBucket`. |
| `GET Reductions/path` | `source`, `target` | The cheapest chain of reductions, weighted by each reduction's declared cost: `{"found": true, "nodes": [...], "hops": [{"from", "to", "className", "cost"}]}`. `found` is `false` when either name is unknown, they are the same problem, or no chain exists. |
| `GET NPC_NavGraph/availableReductions` | `chosenProblem` | Every problem reachable from this one through reductions. |
| `GET NPC_NavGraph/reductionPath` | `reducingFrom`, `reducingTo` | The shortest chain by number of steps, as a list of steps, each a list of reduction class names. |
| `GET ComplexityClasses`, `ProblemTypes`, `ProblemVariants`, `ReductionTypes`, `ReductionCosts`, `SolverTypes`, `SolverComplexityBuckets`, `VisualizationTypes` | none | The allowed values of each tag. |
| `GET ContributorProfile/names`, `/directory`, `/{name}` | none | The people who built Redux, as shown on the website's About page. |

## Generators and templates

| Route | Query | Returns |
| --- | --- | --- |
| `GET /ProblemGenerator/Sat3` | `n` (variables), `c` (clauses) | A random 3SAT instance, ready to use. |
| `GET /ProblemGenerator/UndirectedGraph`, `DirectedGraph` | `n` (nodes), `density` (percent of possible edges), `k` (`-1` for none) | A random graph, written `{{nodes},{edges},k}`. |
| `GET /ProblemTemplate` | `problemName` | A zip of starter files for a new problem. |
| `GET /ProblemTemplate/solver`, `/verifier`, `/visualization` | `problemName` plus `solverName`, `verifierName`, or `visualizationName` | A zip of starter files for that piece. |
| `GET /ProblemTemplate/reduction` | `problemFrom`, `problemTo`, `reductionName` | A zip of starter files for a reduction. |

!!! warning "Generated graphs need reshaping"

    The graph generators write `{{nodes},{edges},k}`, but graph problems such as CLIQUE expect
    `((nodes,edges),k)`. Sending a generated graph straight to CLIQUE answers
    [`instance_parse_error`](errors.md#instance_parse_error).

## Health

`GET /health` answers `ok` as plain text when the API is running. It does no other work.

## Quirks to know

These are how the API behaves today, as of `408f18b`:

- An unknown name in `verify?verifier=` or `problemInstance?problem=` returns **HTTP 500**, not
  a 400 with an error code. Unknown names in the other routes return a 400.
- `Problem_SolversRefactor` and `Problem_VerifiersRefactor` answer an unknown problem with HTTP
  200 and a string instead of a list: `"entered a solver that does not exist"` or
  `"entered a verifier that does not exist"`. `Problem_VisualizationsRefactor` answers with `[]`.
- The `problemType` parameter of the `Problem_*Refactor` routes is accepted and ignored.
- A missing required query parameter, or a body that isn't a JSON string, gets ASP.NET's standard
  validation response instead of a Redux error. See
  [Responses that aren't Redux errors](errors.md#responses-that-arent-redux-errors).
