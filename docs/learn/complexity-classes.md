---
description: What P, NP, NP-complete, NP-hard, and the quantum classes mean, and how Redux labels its problems with them.
sources:
  - Redux:Interfaces/ProblemInterface.cs
  - Redux:Interfaces/Tags.cs
  - Redux:Problems/**/*_Class.cs
---

# Complexity classes

What do P, NP, NP-complete, and NP-hard mean, and why does Redux put every problem in one of
them?

--8<-- "includes/faculty-review.md"

## The short version

- **P**: problems a computer can *solve* quickly.
- **NP**: problems where a computer can quickly *check* a proposed answer.
- **NP-complete**: the hardest problems in NP. A fast algorithm for any one of them would give a
  fast algorithm for all of NP.
- **NP-hard**: problems at least that hard, which may not be in NP themselves.

Nobody knows whether P and NP are the same class. That is the most famous open question in
computer science.

## What "quickly" means

"Quickly" means **polynomial time**: the number of steps grows like *n*, *n*², or *n*³ as the
instance size *n* grows. The alternative to watch for is **exponential time**, such as 2ⁿ, where
each extra item roughly doubles the work.

| *n* | *n*² | *n*³ | 2ⁿ |
| ---: | ---: | ---: | ---: |
| 10 | 100 | 1,000 | 1,024 |
| 20 | 400 | 8,000 | 1,048,576 |
| 40 | 1,600 | 64,000 | 1,099,511,627,776 |
| 60 | 3,600 | 216,000 | 1,152,921,504,606,846,976 |

At a billion steps a second, 2⁴⁰ steps take about 18 minutes and 2⁶⁰ take about 36 years. *n*³
stays under a millisecond the whole way. That is why the line between polynomial and
exponential matters more than any particular computer's speed.

## P: solvable in polynomial time

A problem is in **P** if some algorithm solves every instance in polynomial time. Finding the
shortest path between two cities, or the cheapest way to connect a network (a minimum spanning
tree), are classic examples.

Strictly, P is a class of yes-or-no [decision problems](problems-and-instances.md#decision-and-optimization).
Redux also files problems like shortest paths and minimum spanning trees under P, because they
can be solved in polynomial time.

## NP: checkable in polynomial time

A decision problem is in **NP** if every "yes" instance has a
[certificate](problems-and-instances.md#a-certificate-is-an-answer-you-can-check) that can be
*checked* in polynomial time.

3SAT is in NP. Given an assignment of true and false to the variables, you can check every clause
in one pass. But *finding* an assignment may seem to require trying all 2ⁿ of them, and no one
knows a way around that in general.

The name means **nondeterministic polynomial time**, not "not polynomial". It comes from an
imaginary machine that guesses the right certificate and then checks it.

Every problem in P is also in NP: if you can solve an instance quickly, you can check a "yes"
answer quickly by solving it again. Whether the reverse holds, that every problem whose answers
can be checked quickly can also be solved quickly, is the **P versus NP** question. It is one of
the Clay Mathematics Institute's Millennium Prize Problems. Most computer scientists believe
P ≠ NP, but no one has proved it.

## NP-hard and NP-complete: the hardest ones

A problem is **NP-hard** if every problem in NP can be
[reduced](reductions.md) to it in polynomial time. In other words, a fast algorithm for it could
be used to solve everything in NP quickly.

A problem is **NP-complete** if it is NP-hard *and* in NP itself. These are the hardest problems
inside NP.

The first problem proved NP-complete was SAT, by Stephen Cook in 1971 (the Cook–Levin theorem).
In 1972 Richard Karp used reductions to show that 21 more problems are NP-complete, including
Clique, Vertex Cover, Set Cover, Graph Coloring, and Subset Sum. Since then thousands of problems
have been added the same way: reduce a known NP-complete problem to the new one.

An NP-hard problem doesn't have to be in NP. Many are **optimization** problems, such as "find
the *largest* cut of this graph", because an answer to them can't be checked just by looking at
it. Their yes-or-no versions ("is there a cut of size at least *k*?") are often NP-complete.

## Quantum classes

Redux also has a few problems that show what quantum computers do differently.

- **EQP** (exact quantum polynomial time): a quantum computer solves them in polynomial time and
  is always right.
- **BQP** (bounded-error quantum polynomial time): a quantum computer solves them in polynomial
  time and is right with high probability.

Most of these problems are about a hidden function, called an *oracle*. They count how many
times you must ask it a question. The Deutsch–Jozsa problem needs one quantum question, while a
classical computer that must always be right needs exponentially many in the worst case.

Quantum speed-ups are not magic. Grover's algorithm searches *N* items in about √*N* steps
instead of *N*, a real but only quadratic gain. Nobody knows a fast quantum algorithm for any
NP-complete problem.

## How Redux labels its problems

Each problem declares one class. As of 2026-11-06 the labels are:

| Class | How many | Examples in Redux |
| --- | ---: | --- |
| P | 13 | Minimum Spanning Tree, Topological Sort, Edit Distance, DFA Acceptance, Single Source Shortest Path |
| NP-complete | 27 | 3SAT, SAT, Clique, Vertex Cover, Independent Set, Graph Coloring, Subset Sum, Partition, Hamiltonian Cycle, Traveling Salesperson |
| NP-hard | 5 | Max Cut, Minimum Vertex Cover, Weighted Max-SAT, two Pump Scheduling problems |
| NP | 1 | Prime Factorization |
| EQP | 3 | Deutsch, Deutsch–Jozsa, Bernstein–Vazirani |
| BQP | 2 | Simon's Problem, Unstructured Search |

Prime Factorization is labelled NP rather than NP-complete. Its decision version is in NP, but
it isn't believed to be NP-complete, and Shor's algorithm factors in polynomial time on a quantum
computer.

To see the current labels, filter by **Complexity Class** on the website's **Browse** page, or
call [`/Navigation/ComplexityClasses`](../reference/api.md#discovery) and read each problem's
`complexityClass`.

## Common misconceptions

- **"NP means not polynomial."** It means nondeterministic polynomial. Every problem in P is in
  NP.
- **"NP-complete problems can't be solved."** They can, and Redux solves them. What no one knows
  is how to solve *every* instance in polynomial time. Small instances are fine. Large ones blow
  up.
- **"NP-hard means in NP and hard."** An NP-hard problem only has to be at least as hard as NP. It
  can sit outside NP, as many optimization problems do.
- **"Quantum computers will solve NP-complete problems quickly."** Not as far as anyone knows.
  Their known big speed-ups are for special problems such as factoring.

## How Redux shows it

- The problem dropdown on [redux.isu.edu][redux-site] lists problems in order of complexity
  class, with a tag on each showing its class. Its filter menu narrows the list by class.
- The ⓘ button on a **solver** shows its growth rate (for example `2^n * n^2 * m` for Clique's
  brute-force solver) and a bucket such as Polynomial or Exponential.
- Try a brute-force solver on a bigger and bigger instance. Every request stops after 10 seconds,
  and an exponential solver reaches that limit quickly. See
  [`time_limit`](../reference/errors.md#time_limit).

## Further reading

- S. A. Cook, "[The complexity of theorem-proving procedures](https://doi.org/10.1145/800157.805047)",
  *STOC* 1971.
- R. M. Karp, "[Reducibility among combinatorial problems](https://doi.org/10.1007/978-1-4684-2001-2_9)",
  1972.
- M. Sipser, *Introduction to the Theory of Computation*, chapter 7.
- [P versus NP](https://www.claymath.org/millennium/p-vs-np/) at the Clay Mathematics Institute.
