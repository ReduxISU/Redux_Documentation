---
description: Why checking an answer is easier than finding one, and how Redux's solvers and verifiers show the difference.
sources:
  - Redux:Interfaces/SolverInterface.cs
  - Redux:Interfaces/VerifierInterface.cs
  - Redux:Problems/**/Solvers/**
  - Redux:Problems/**/Verifiers/**
  - Redux:Documentation/guides/adding-a-solver.md
  - Redux:Documentation/guides/adding-a-verifier.md
---

# Solving and verifying

Why is checking an answer so much easier than finding one, and what do Redux's solvers and
verifiers each do?

--8<-- "includes/faculty-review.md"

## The short version

A **solver** finds an answer to an instance. A **verifier** checks whether a given answer, a
[certificate](problems-and-instances.md#a-certificate-is-an-answer-you-can-check), really works.
For problems in [NP](complexity-classes.md#np-checkable-in-polynomial-time), checking is fast even
when finding seems to require trying almost everything. That gap between finding and checking is
what NP is about.

## Finding versus checking

Think of a Sudoku. Filling in a blank grid takes real effort. Checking a filled-in grid is quick:
look at each row, column, and box for a repeated digit.

3SAT works the same way. For a formula with *n* variables there are 2ⁿ ways to set them to true
and false:

- To **check** one assignment, go through the clauses once and confirm each has a true literal.
  The work grows with the length of the formula.
- To **find** an assignment, the simplest method is to try them one by one. With 3 variables that
  is 8 tries. With 40 it is over a trillion.

Clever solvers do better than trying everything, but for NP-complete problems no one knows a
method that is fast on *every* instance.

## Kinds of solvers

Redux usually has several solvers for one problem, so you can compare them. Each solver's ⓘ
button on the website shows its type and how its work grows. For 3SAT and Vertex Cover, as of
2026-11-06:

| Solver | Type | Work grows like | What it does |
| --- | --- | --- | --- |
| 3SAT Backtracking | Backtracking | 2ⁿ · \|φ\| | Tries assignments, but abandons a partial one as soon as a clause is false |
| Schöning's k-SAT Algorithm | Heuristic | (4/3)ⁿ | Random restarts with random local fixes |
| WalkSAT | Heuristic | *n* · *m* | Flips one variable at a time toward fewer false clauses. Fast, but it can miss an answer that exists. |
| Vertex Cover Brute Force | Brute force | 2ⁿ · *n* · (*n* + *m*) | Tries every subset of nodes |
| Vertex Cover Bounded Search Tree | Backtracking | 2ᴷ · (*n* + *m*) | Branches on each edge's two ends, at most *K* deep |
| Vertex Cover Approximation | Approximation | *E* | Polynomial, and finds a cover at most twice the smallest |

Here *n* is the number of variables or nodes, *m* the number of clauses or edges, \|φ\| the length
of the formula, and *K* the cover size asked for. The Bounded Search Tree's work grows with *K*
rather than *n*, which makes it fast when the answer is small. Algorithms like that are called
**parameterized**.

An **approximation** algorithm trades exactness for speed. It runs in polynomial time and
guarantees an answer within a known factor of the best one. A **heuristic** is often fast in
practice but guarantees less.

## What a verifier answers

A verifier takes an instance and a certificate and answers `True` or `False`. It never searches.

- `True` means *this* certificate answers *this* instance.
- `False` means this certificate doesn't. It says nothing about whether some other certificate
  would.

Optimization problems show where checking stops being easy. Redux's Weighted Max-SAT has two
verifiers:

- The **Solution Verifier** checks that a certificate is a valid assignment and reports its
  value. That is fast.
- The **Optimality Verifier** also confirms no other assignment does better. To do that it tries
  them all, taking about 2ⁿ steps.

"Is this good enough?" is easy to check. "Is this the best possible?" generally isn't. That is
one reason many optimization problems are
[NP-hard but not in NP](complexity-classes.md#np-hard-and-np-complete-the-hardest-ones).

## Common misconceptions

- **"A verifier tells you whether an instance has a solution."** It only checks the one
  certificate you give it. `False` can mean the instance has no solution, or that you gave the
  wrong one.
- **"Brute force is wrong."** Brute force is always correct, only slow. It is the easiest solver
  to trust, so it is a good reference for testing faster ones.
- **"A fast solver means the problem is easy."** A heuristic can be fast on the instances you try
  and still be slow, or wrong, on others. Hardness is about the worst case.

## How Redux shows it

On [redux.isu.edu][redux-site]:

1. Pick **3SAT** and open the **Solve** row. Choose a solver and select **Solve**.
2. Copy the solution into the **Verify** row's certificate box and select **Verify**. The
   verifier output reads `True`.
3. Change one `True` in the certificate to `False` and verify again. It may now read `False`.
4. Make the instance bigger and compare solvers. A brute-force solver soon runs into the
   10-second limit, and the error suggests faster solvers. See
   [`time_limit`](../reference/errors.md#time_limit).

## Further reading

- M. Sipser, *Introduction to the Theory of Computation*, section 7.3 (the class NP and
  verifiers).
- [Approximation algorithm](https://en.wikipedia.org/wiki/Approximation_algorithm) on Wikipedia.
