---
description: A fifteen-minute first session on redux.isu.edu - solve a 3SAT formula, check the answer, reduce it to Clique, and watch the reduction.
sources:
  - Redux_GUI:pages/index.js
  - Redux_GUI:components/pageblocks/**
  - Redux_GUI:components/Visualization/**
  - Redux:Problems/NPComplete/NPC_SAT3/**
---

# Your first session

In this tutorial you solve a logic puzzle, check the answer, turn the puzzle into a graph
problem, and watch how the answer carries across. By the end you will have used all five parts
of the Redux workbench.

**Time:** about 15 minutes · **You need:** a web browser on a computer. The workbench needs a
wide screen, so phones are hard to use.

## Open Redux and look at the problem

1. Go to [redux.isu.edu][redux-site].
2. Look at the top row, **Problem**. It already shows **3SAT** with this instance:

    ```text
    (x1 | x2 | x3) & (!x1 | !x2 | !x3) & (!x1 | x2 | x3) & (x1 | !x2 | x3)
    ```

3. Select the ⓘ button at the right of the Problem row.

You should see a box describing 3SAT: its input, its output, a definition, its complexity class
(**NP-Complete**), and where it comes from.

This instance is a formula with three variables and four clauses. `|` means "or", `&` means
"and", and `!` means "not". The question 3SAT asks is: can you set each variable to true or false
so that every clause has at least one true part? Close the box when you're done.

## Solve it

1. Find the **Solve** row. It starts closed, so select the ▼ button at its right end to open it.
2. The solver is already set to **3SAT Backtracking**. Select **Solve**.

You should see:

```text
Solution: (x1:True,x2:True,x3:False)
```

That is a **certificate**: a proposed answer, setting x1 and x2 to true and x3 to false.

## Check the answer

1. Open the **Verify** row with its ▼ button. The verifier is **3SAT Solution Verifier**.
2. In the box under **Enter a certificate:**, type `(x1:True,x2:True,x3:False)`.
3. Select **Verify**.

You should see **Verifier output: True**.

Now try a wrong answer. Change the certificate to `(x1:True,x2:True,x3:True)` and select
**Verify** again. You should see **Verifier output: False**. The second clause,
`(!x1 | !x2 | !x3)`, needs at least one variable to be false.

Finding the answer took a search. Checking it took one pass over the clauses. That difference is
what [Solving and verifying](../learn/solving-and-verifying.md) is about.

## Reduce it to Clique

Look at the **Reduce** row at the bottom of the page. It is already set to reduce to **Clique**,
using **Sipser's Clique Reduction**, and it has already run.

You should see **Reduced Clique Instance:** followed by a graph. The graph has one node for each
literal in each clause, named like `x1_0`, meaning literal `x1` in clause 0. The question for
this graph is: does it have a clique of 4 nodes, one for each clause? A clique is a group of
nodes where every pair is joined by an edge.

## Watch the reduction

Go back up to the **Visualize** row. It shows the formula, one box per clause.

1. Turn on **Show reduction**. The formula moves to the left and the Clique graph appears on the
   right.
2. Turn on **Highlight gadgets**, then point at a node in the graph, such as `x1_0`. The
   literal it came from, `x1` in the first clause, lights up on the left. So does that clause.
3. Turn on **Highlight solution**. On the left, the literals made true by the solution turn
   green. On the right, four nodes turn green: a clique with one node from each clause.

You should see the true literals and the four clique nodes highlighted on both sides at once.

## What you just did

You answered a 3SAT question by finding a certificate and checked it with a verifier. Then you
turned the same question into a Clique question, and saw that the satisfying assignment
corresponds to a clique of the right size. That correspondence, worked out for every possible
formula, is the proof that Clique is at least as hard as 3SAT. It is how computer scientists
show a problem is NP-complete.

## Next

- [Reductions](../learn/reductions.md) explains why this construction works, on a smaller
  example.
- [The workbench](workbench.md) describes every control you used, and the ones you didn't.
- [Write an instance](instances.md) shows how to type in your own formulas and graphs.
