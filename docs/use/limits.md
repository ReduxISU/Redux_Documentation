---
description: What the site does when a request takes too long, the server is busy, or the quantum service is down, plus the known gaps in the site.
sources:
  - Redux:Interfaces/ComputeLimits.cs
  - Redux:Interfaces/ComputeJobs.cs
  - Redux:Interfaces/SolverUnavailableException.cs
  - Redux_GUI:components/pageblocks/SolveRowReact.js
  - Redux_GUI:components/redux/index.js
---

# Limits and known issues

This page lists what Redux stops, what it refuses, and what doesn't work yet, with the message you
see for each.

!!! info "Checked against `Redux@408f18b` and `Redux_GUI@a056f6c` on 2026-11-07"

    These are the current versions of the API and the website, run locally. The live site at
    [redux.isu.edu][redux-site] is updated from them from time to time. Where the live site
    behaves differently today, a box says so.

## A request takes too long

Every computation, whether a solve, verify, reduce, or drawing, stops after **10 seconds**. Hard
problems on large instances reach that quickly, because the work can double with every item
you add.

**What you see:** the **Solve** row shows *"The solve ran past the 10-second time limit, so it
was stopped."* and a suggestion. The suggestion usually names faster solvers for the same
problem, such as *Carraghan–Pardalos* or *Chiba–Nishizeki* for Clique.

**What to do:** use a smaller instance, or pick one of the suggested solvers in **Select
Solver**.

The **Visualize** row behaves differently. A search stopped by the limit is still drawn, up to
the point where it stopped.

!!! warning "The live site doesn't have this limit yet"

    Until the live site is updated, a slow request there isn't stopped. It can run for a very long
    time without an answer, and it keeps using the server even after you close the page. Keep
    instances on redux.isu.edu close to the size of the examples.

## The server is busy

Only a limited number of computations run at once. When all of those slots are full, a new request
isn't started.

**What you see:** *"The server is busy with other jobs right now, so this one wasn't started."*
and *"Wait about 5 seconds and try again."*

**What to do:** wait a few seconds, then select the button again.

## The quantum service is down

Quantum solvers, such as *Deutsch's Algorithm*, Grover's search for SAT, and Shor's algorithm
for Prime Factorization, run on a separate quantum service. If Redux can't reach it, the solve
fails, and every other solver still works.

**What you see:** for example *"Deutsch's Algorithm couldn't get an answer from the quantum
service, so Deutsch wasn't solved."*, then a suggestion of a classical solver for the same
problem.

**What to do:** choose the suggested classical solver, or try again later. The quantum circuit
pictures still draw.

## An instance can't be read

For 3SAT, Clique, Vertex Cover, Graph Coloring, and Feedback Arc Set, the instance box itself
warns you with **Incorrect Format**. For other problems, **Solve** shows the reason the instance
couldn't be read, such as *Braces not matched*, in place of an answer.

!!! warning "On the live site, today"

    For problems other than those five, the live site doesn't show the reason yet. **Solve** shows
    an empty answer instead.

[Write an instance](instances.md) has examples and common mistakes.

## Known gaps in the site

| Gap | Details |
| --- | --- |
| **Phones** | On narrow screens the tabs at the top disappear and the rows run off the right edge. Use a computer or a tablet. |
| **Shared links** | Opening a shared link restores only the problem. The instance and other choices go back to their defaults. See [Share](workbench.md#share). |
| **Step captions** | The API describes each step of a search in a sentence, but the website doesn't show these yet. |
| **Unreachable targets** | The **Reduce** row lets you pick a target with no reduction path. Nothing happens. |
| **Problems with no picture** | Some problems have no visualization. The **Visualize** row says *No renderable visualization for this problem*. |

To report something that isn't on this list, open an issue on [Redux][repo-redux] or
[Redux_GUI][repo-gui], or ask on the [Discord][redux-discord].

## Related

- [API errors](../reference/errors.md) gives the technical detail behind each message, for
  programs that call the API.
