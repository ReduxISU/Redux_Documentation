---
description: Redux is Idaho State University's interactive knowledgebase of canonical computer science problems, solutions, and reductions.
sources:
  - Redux:Readme.md
  - Redux_GUI:pages/aboutus/index.js
---

# Redux

Redux is an interactive knowledgebase of canonical computer science problems. Idaho State
University built it to teach computational complexity. Pick a problem, such as 3SAT, Clique, or
Vertex Cover, and give it an instance. Redux can solve it, check a proposed answer, reduce it to
another problem, and draw each step.

The collection starts from Karp's 21 NP-complete problems and reaches into P, NP-hard, and
quantum problems. **Reductions**, which turn one problem into another, are at its center.
Computer scientists use them to prove that a problem is hard, and Redux lets you watch one
happen.

Students and faculty at Idaho State University build Redux, and student contributions are
welcome.

[Open Redux][redux-site]{ .md-button .md-button--primary }
[Join the Discord][redux-discord]{ .md-button }

## Where to start

<div class="grid cards" markdown>

-   :material-play-circle: **Use Redux**

    ---

    Solve, verify, reduce, and visualize problems in your browser at [redux.isu.edu][redux-site].
    Start with [your first session](use/first-session.md).

-   :material-school: **Learn the ideas**

    ---

    What P, NP, and NP-complete mean, and how a
    [reduction](learn/reductions.md) proves a problem is hard.

-   :material-api: **Call the API**

    ---

    Everything the site does is a REST call. See the [API reference](reference/api.md), or try
    the calls in [Swagger][redux-swagger].

-   :material-source-pull: **Contribute code**

    ---

    Add a problem, solver, verifier, reduction, or visualization. Start with the
    [Redux contributor guides](https://github.com/ReduxISU/Redux/blob/HEAD/Documentation/guides/README.md).

-   :material-file-document-edit: **Improve these docs**

    ---

    Fix a page or preview the site. See [Redux_Documentation](contribute/redux-documentation.md).

</div>

## The projects

Redux is several projects that work together. Each one is a repository in the
[ReduxISU organization][redux-org] on GitHub.

| Project | What it does |
| --- | --- |
| [Redux][repo-redux] | The API. It holds every problem, solver, verifier, reduction, and visualization. C# on ASP.NET Core. |
| [Redux_GUI][repo-gui] | The website at [redux.isu.edu][redux-site]. Next.js and React. |
| [quantumsolver][repo-quantum] | Runs the quantum algorithms, such as Grover's search and Shor's factoring, for Redux. Python and Qiskit. |
| [SPADE][repo-spade] | The library Redux uses to read problem instances such as `(({a,b,c},{{a,b},{b,c}}),2)`. C#. |
| [mcpredux][repo-mcp] | Lets AI assistants use Redux through the Model Context Protocol. Python. |
| [Redux_VR][repo-vr] | A prototype 3D and VR view of reductions. React Three Fiber. |
| [Redux_Build_System][repo-rbs] | `rbs`, the tool that checks, builds, and publishes the other projects. Python. |
| [admin][repo-admin] | The organization's rules for pull requests and reviews, kept as code. |

## About these docs

This site is becoming the one place for Redux documentation. It serves people who use Redux,
people who build it, and later the AI agents that help build it. Until a topic moves here, the
links above go to where it lives today.
