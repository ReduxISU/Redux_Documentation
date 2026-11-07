---
description: Ideas for using Redux in a complexity or algorithms course, how to link students to a problem, and how to cite Redux.
sources:
  - Redux_GUI:pages/index.js
  - Redux_GUI:pages/aboutus/index.js
  - Redux:Interfaces/Tools/ProblemInstanceGenerators.cs
  - Redux:CITATION.cff
---

# Teach with Redux

Redux was built for teaching computational complexity. This page collects ways to use it in a
course: in lecture, in exercises, and as a project students contribute to.

--8<-- "includes/faculty-review.md"

## Before you start

- Work through [Your first session](first-session.md) yourself. It takes about 15 minutes and
  touches every part of the site.
- Students need only a browser on a computer. The workbench is hard to use on a phone. See
  [Limits and known issues](limits.md#known-gaps-in-the-site).

## Send students straight to a problem

Link to a problem by its API name. The workbench opens with that problem and its example
instance:

```text
https://redux.isu.edu/?problem=CLIQUE
https://redux.isu.edu/?problem=VERTEXCOVER
https://redux.isu.edu/?problem=SUBSETSUM
```

Only the problem carries over in a link, not an instance. To hand out a specific instance, put
the text in the assignment and have students paste it into the **Problem Instance** box.

## Ideas for class

Each idea points to the page that explains the concept behind it.

**Finding versus checking** ([Solving and verifying](../learn/solving-and-verifying.md))

1. Have students solve a 3SAT instance, then paste the answer into **Verify**.
2. Have them break the answer by changing one value, and predict whether the verifier will still
   say `True`.
3. Ask why verifying took one pass while solving took a search.

**How fast does it grow?** ([Complexity classes](../learn/complexity-classes.md))

1. Compare the solvers for one problem. Clique, for example, has a brute-force solver and two
   faster exact ones.
2. Open each solver's ⓘ box to read its growth rate. Discuss what an exponential term means as
   instances grow.

!!! warning "Keep live-site instances small for now"

    Until the live site gets its time limit, a very large instance can occupy the server for a
    long time. See [Limits and known issues](limits.md#a-request-takes-too-long). For growth
    experiments, ask the Redux team for a local copy, or keep instances near the example size.

**Trace a reduction** ([Reductions](../learn/reductions.md))

1. Reduce 3SAT to Clique, turn on **Show reduction** and **Highlight gadgets**, and point at
   nodes to see where each came from.
2. Turn on **Highlight solution**, and have students explain why the highlighted nodes form a
   clique exactly when the formula is satisfied.
3. Have them predict the size of the graph for a formula with *m* clauses before checking.

**Follow a chain** ([Reduce one problem to another](reduce.md))

1. On the **Browse** page, set **Reachable from** to 3SAT and compare *One reduction* with *Any
   reductions*.
2. Pick a problem two steps away, and have students explain what each step of the chain
   preserves.

## Fresh instances for exercises

The API can make random instances:

```text
https://redux.isu.edu/api/redux/ProblemGenerator/Sat3?n=4&c=5
```

That returns a random 3SAT formula with 4 variables and 5 clauses, ready to paste into the
workbench. See [Generators and templates](../reference/api.md#generators-and-templates). The
graph generators' output needs reshaping before Clique and similar problems accept it.

## Students as contributors

Redux is built largely by students. Adding a problem, solver, verifier, reduction, or
visualization makes a substantial course project, and a merged one becomes part of the site.
The step-by-step guides currently live in the
[Redux repository](https://github.com/ReduxISU/Redux/blob/HEAD/Documentation/guides/README.md).

!!! note "Evolving"

    A table matching course assignments to the contributor guides is in review in
    [Redux pull request #987](https://github.com/ReduxISU/Redux/pull/987).

## Cite Redux

When citing Redux, use:

> Kaden Marchetti, Andrija Sevaljevic, Alex Diviney, Caleb Eardley, Russell Phillips, Rajiv
> Khadka, Daniel Igbokwe, and Paul Bodily. 2024. Redux: An Interactive, Dynamic Knowledge Base
> for Teaching NP-completeness. In *Proceedings of the 2024 on Innovation and Technology in
> Computer Science Education V. 1 (ITiCSE 2024)*. Association for Computing Machinery, New York,
> NY, USA, 255–261. <https://doi.org/10.1145/3649217.3653544>

The site's **About Us** page lists the team's other publications.

## Get help

Ask on the [Redux Discord][redux-discord], or open an issue on [Redux][repo-redux] for problems
with the problems themselves, or on [Redux_GUI][repo-gui] for problems with the website.
