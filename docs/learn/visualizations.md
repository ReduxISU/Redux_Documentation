---
description: What Redux's pictures show, how a solver's steps become frames, and how a reduction is drawn side by side.
sources:
  - Redux:Interfaces/VisualizationInterface.cs
  - Redux:Interfaces/Steps/**
  - Redux:Interfaces/VisualizationType.cs
  - Redux:Documentation/guides/adding-a-visualization.md
  - Redux_GUI:components/pageblocks/VisualizeRowReact.js
  - Redux_GUI:components/Visualization/**
---

# Visualizations

What are you looking at when Redux draws a problem, and how does a picture show a solver
working or a reduction translating?

--8<-- "includes/faculty-review.md"

## The short version

Redux draws an instance, the steps a solver takes on it, and the solution it finds, as a
sequence of pictures called **frames**. For a reduction it can draw both problems side by side
and highlight which parts of one became which parts of the other.

## Data first, drawing second

Redux splits the work in two. The API works out *what* to show: which nodes exist, which are part
of the answer, what the solver tried. It sends that as data. The website then draws the data.

Because the picture is data, other tools can draw the same thing their own way. That includes
the [Redux VR][repo-vr] prototype, which shows reductions in 3D, and AI assistants that read the
data directly.

Each visualization declares a **picture type** that says how to draw it:

| Kind of picture | Used for, for example |
| --- | --- |
| A graph of nodes and edges | Clique, Vertex Cover, Independent Set, Max Cut |
| A diagram of sets | Set Cover, Exact Cover, Partition |
| A boolean formula, clause by clause | SAT, 3SAT |
| A quantum circuit | Deutsch, Deutsch–Jozsa, Shor's factoring |
| A table | DFA and NFA runs, shortest paths |
| A schedule | Pump Scheduling |

Some problems have no picture yet. On the website their visualizations are greyed out and
marked *no renderer available*.

## Frames: the instance, the steps, the answer

A visualization produces frames in order:

1. **The instance** as it was given, with nothing highlighted.
2. **The solver's steps**, one frame per step, for solvers that record them.
3. **The solution**, with the answer highlighted.

A solver that records its steps reports each one as an event:

| Event | Meaning |
| --- | --- |
| Try | Consider adding this piece to the answer. |
| Accept | It fits; keep it. |
| Reject | It doesn't fit. |
| Backtrack | Undo an earlier choice and try another way. |
| Done | The search is over, with or without an answer. |

Each step also carries a one-line **caption**. For a small Clique instance, Clique's brute-force
solver says *"Try {a,b,c}. Every pair is joined."* and then *"{a,b,c} is a clique, found after 1
tries."* Stepping through the frames shows the search as it happened. A backtracking solver
visibly backs out of dead ends. If the search runs past Redux's time limit, the frames stop
there, and the last caption says how many steps were taken.

## Drawing a reduction

A [reduction](reductions.md) has two sides, the original instance and the one it was turned
into. Redux can show both:

- **Side by side.** The original problem on one side and the reduced problem on the other.
- **Gadgets highlighted.** Matching colors show which part of the original became which part of
  the result, such as each 3SAT clause and its group of three nodes in the Clique graph.
- **Solution highlighted.** The answer on both sides at once, so you can see how an answer
  carries across.

This is often the clearest way to understand why a reduction is correct. You can see that a
clique in the graph picks one true literal from each clause.

## Common misconceptions

- **"The picture is the proof."** A picture shows one instance. The proof that a reduction works
  covers every instance. The picture helps you see why, but it isn't the argument.
- **"Every frame is one step of the algorithm's running time."** Frames show the decisions a
  solver makes, not every operation it performs. Two solvers with similar-looking frames can
  differ greatly in running time.
- **"No picture means no solver."** A problem can have working solvers and verifiers before
  anyone has written its visualization.

## How Redux shows it

On [redux.isu.edu][redux-site], the **Visualize** row draws the current instance:

- **Refresh** goes back to the first frame and turns the switches below off.
- The arrow buttons step backward and forward through the frames. The outer ones jump to the
  first and last frame.
- **Highlight solution** jumps to the solved frame.
- **Show reduction** shows both sides once you have chosen a reduction in the **Reduce** row.
  Until then it is turned off. **Highlight gadgets** colors the parts that correspond.

## Further reading

- [Redux API: `visualize`](../reference/api.md#problem-provider), for the data behind each frame.
- The [Redux VR][repo-vr] prototype, a 3D view of both sides of a reduction.
