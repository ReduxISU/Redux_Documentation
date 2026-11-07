---
description: Short definitions of the words used across Redux and its documentation.
sources:
  - Redux:Interfaces/**
  - Redux:Documentation/guides/**
  - Redux_Build_System:README.md
---

# Glossary

Short definitions of the words these docs use. Words in **bold** inside a definition have their
own entry.

## Problems and complexity

Problem
:   A general question with a precise definition, such as "does this graph have a clique of size
    *k*?". In Redux, every problem is a class with a name like `CLIQUE` or `SAT3`.

Instance
:   One specific case of a **problem**: this particular graph and this *k*, or this particular
    formula. Redux reads an instance from an **instance string**.

Instance string
:   An instance written as text, such as `(({1,2,3},{{1,2},{2,3}}),2)` for a graph and a number.
    Each problem's `instanceFormat` says how to write one.

Certificate
:   A proposed answer to an instance that can be checked: a set of nodes for Clique, or a true/false
    value for each variable for 3SAT. Each problem's `certificateFormat` says how to write one.

Decision problem
:   A problem whose answer is yes or no, such as "is there a clique of size *k*?".

Optimization problem
:   A problem that asks for the best answer, such as "what is the largest clique?".

Complexity class
:   A group of problems that need similar resources to solve. Redux labels every problem with one.

P
:   The problems a computer can solve in polynomial time, meaning time that grows like *n*, *n*²,
    or *n*³ as the input size *n* grows, rather than like 2ⁿ.

NP
:   The decision problems whose "yes" answers have a **certificate** that can be checked in
    polynomial time. Every problem in **P** is also in NP.

NP-hard
:   At least as hard as every problem in **NP**. Every NP problem **reduces** to an NP-hard
    problem in polynomial time. An NP-hard problem doesn't have to be in NP itself.

NP-complete
:   Both in **NP** and **NP-hard**. These are the hardest problems in NP. If any one of them had a
    polynomial-time algorithm, every problem in NP would. Karp's 21 problems from 1972 are the
    classic set.

EQP and BQP
:   Classes of problems that a quantum computer can solve in polynomial time: exactly (EQP), or with
    a small chance of error (BQP). Redux's Deutsch, Deutsch–Jozsa, and Bernstein–Vazirani problems
    are in EQP. Simon's problem and unstructured search are in BQP.

## What Redux does with a problem

Solver
:   Code that finds an answer to an instance. A problem can have several, such as a brute-force
    search and a faster algorithm. One of them is the problem's default.

Verifier
:   Code that checks whether a **certificate** really answers an instance. It answers `True` or
    `False`.

Reduction
:   A way to turn any instance of one problem into an instance of another, so that the answer
    carries over. If problem A reduces to problem B in polynomial time, B is at least as hard as
    A. Reductions are how hardness is proved.

Reduction chain
:   Several reductions applied one after another, such as SAT3 to CLIQUE to VERTEXCOVER.

Gadget
:   A piece of a reduction's output that stands for a piece of its input, for example the group of
    nodes that stands for one clause. Redux records gadgets so a visualization can show which
    part became which.

Mapping a solution
:   Carrying an answer across a reduction. *Forward* takes an answer of the source problem to an
    answer of the target. *Back* takes an answer of the target to an answer of the source. Not
    every reduction can map back.

Visualization
:   Code that turns an instance, and optionally a solver's steps and answer, into pictures. The API
    returns the pictures as data, and the website draws them.

Frame
:   One picture in a visualization's sequence: the starting instance, one step of a solver, or the
    solved instance.

Picture type
:   The kind of drawing a visualization produces, such as `Graph` or `BooleanSatisfiability`.
    The website picks how to draw each frame by its picture type.

Default
:   The solver, verifier, or visualization a problem uses when you don't pick one. The default
    instance is a ready-made example of the problem.

Class name
:   The name of the C# class behind a problem, solver, verifier, visualization, or reduction,
    such as `Sat3BacktrackingSolver`. The API takes class names, without regard to case.

## The software

Redux API
:   The C# web service, in the Redux repository, that holds every problem and does all the
    solving, verifying, reducing, and drawing. The website and other tools call it.

Endpoint, route
:   One address of the API that does one thing, such as `POST /ProblemProvider/solve`.

Swagger
:   A web page built into the API that lists every endpoint and lets you try each one from the
    browser.

Quantum service
:   quantumsolver, the Python service that runs real quantum circuits for Redux's quantum solvers.

SPADE
:   The C# library Redux uses to read instance strings, using a grammar written in a
    **definition string**.

Definition string
:   The grammar of a problem's instance strings, written for SPADE, such as
    `{((N,E),K) | N is set, E subset N unorderedcross N, K is int}`.

MCP
:   The Model Context Protocol, a standard way for AI assistants to call tools. mcpredux offers
    Redux's features to assistants through it.

## Building and contributing

Repository, repo
:   A project's code and its history, kept on GitHub. Each Redux project is its own repository in
    the ReduxISU organization.

Default branch
:   The branch a repository's pull requests merge into: `CSharpAPI` for Redux, `ReduxAPI_GUI` for
    Redux_GUI, and `main` for everything else.

Pull request, PR
:   A request to merge a branch's changes into the default branch. Other people review it there,
    and the checks run on it.

rbs
:   The Redux Build System, a command-line tool that runs the same checks on your computer, in a
    devcontainer, and on GitHub. It checks dependencies, formatting, lint, and tests, builds the
    container image, tests that image, and publishes it.

Check, `build-test / ci`
:   The automatic test run attached to a pull request. Its name in GitHub is `build-test / ci`. In
    Redux, Redux_GUI, quantumsolver, and mcpredux it must pass before a pull request can merge.

Gate
:   One step of a check, such as the format check or the unit tests. A *hard* gate fails the check
    when it fails. A *soft* one only reports.

Devcontainer
:   A container described by a repository's `.devcontainer/` folder that has every tool the project
    needs. VS Code, Codespaces, and the `devcontainer` command can all open one.

Image
:   A packaged, runnable copy of a service, such as `ghcr.io/reduxisu/redux`. Images are published
    to the GitHub Container Registry (GHCR) and run with Docker.
