---
description: What a problem, an instance, and a certificate are, and how Redux writes each one as text.
sources:
  - Redux:Interfaces/ProblemInterface.cs
  - Redux:Problems/**/*_Class.cs
  - Redux:Documentation/guides/adding-a-problem.md
---

# Problems and instances

What is the difference between a *problem* and an *instance*, and what counts as an answer?

--8<-- "includes/faculty-review.md"

## The short version

A **problem** is a general question, such as "can some of these numbers add up to the target?". An
**instance** is one specific case of it: these numbers and this target. A **certificate** is a
proposed answer to an instance that anyone can check. In Redux you pick a problem, type an
instance as text, and work with certificates.

## A problem is a general question

Subset Sum asks: *given a set of whole numbers and a target, is there a subset that adds up to
exactly the target?*

That question has no single answer, because it doesn't say which numbers. It describes
infinitely many specific questions at once. Computer scientists study problems at this level
because they want to know how hard the *question* is, whatever numbers someone brings.

## An instance is one case of it

Pick the numbers 1, 7, 12, and 15 and the target 28. Now there is one question with one answer.
Redux writes this instance as:

```text
({1,7,12,15},28)
```

Braces `{…}` hold a set, where order doesn't matter. Parentheses `(…)` hold a fixed sequence of
parts, where order does matter. So this instance is "a set of numbers, then a target".

Other problems use the same building blocks:

| Problem | An instance | Read it as |
| --- | --- | --- |
| Subset Sum | `({1,7,12,15},28)` | numbers {1, 7, 12, 15}, target 28 |
| Clique | `(({a,b,c,d},{{a,b},{b,c},{a,c},{c,d}}),3)` | a graph with nodes a–d and four edges, and *k* = 3 |
| A directed graph problem | `(({a,b,c},{(a,b),(b,c),(c,a)}),3)` | edges written `(a,b)` go one way, from a to b |

Formulas use their own notation. A 3SAT instance joins clauses with `&` (and), joins the
literals inside a clause with `|` (or), and writes "not" as `!`:

```text
(x1 | !x2 | x3) & (!x1 | x3 | x1)
```

An undirected edge is a set, `{a,b}`, because `{a,b}` and `{b,a}` are the same edge. A directed
edge is a pair, `(a,b)`, because a→b and b→a are different.

The **size** of an instance, usually written *n*, is roughly how much text it takes: the number of
items, nodes, or variables. How fast the work grows with *n* is what separates easy problems from
hard ones. See [complexity classes](complexity-classes.md).

## Decision and optimization

Many problems come in two forms:

- The **decision** form asks a yes-or-no question. *Does this graph have a clique of 3 nodes?*
- The **optimization** form asks for the best answer. *What is the largest clique in this graph?*

Most of the classic hard problems, including Karp's 21, are stated in decision form, with a
number *k* in the instance to make the question yes-or-no. The two forms are closely linked. If
you can answer "is there a clique of size *k*?" quickly for every *k*, you can find the largest
clique size by trying *k* = 1, 2, 3, and so on.

Redux tags each problem as Decision or Optimization. Clique in Redux is the decision form. Its
instances end with *k*.

## A certificate is an answer you can check

For a decision problem, a **certificate** is evidence for a "yes". For the Subset Sum instance
above, the certificate `{1,12,15}` says "use 1, 12, and 15". Anyone can add them up, get 28, and
be convinced.

| Problem | Instance | A certificate | Why it convinces you |
| --- | --- | --- | --- |
| Subset Sum | `({1,7,12,15},28)` | `{1,12,15}` | 1 + 12 + 15 = 28 |
| Clique | `(({a,b,c,d},{{a,b},{b,c},{a,c},{c,d}}),3)` | `{a,b,c}` | a–b, b–c, and a–c are all edges |

For the 3SAT formula above, the certificate `(x1:True,x2:False,x3:False)` sets each variable to
true or false. It convinces you because every clause then contains a true literal.

Checking a certificate is usually easy, even when finding one is hard. That gap is the heart of
the next pages.

## Common misconceptions

- **"A small instance means an easy problem."** Any instance small enough to type is quick to
  solve. Hardness is about how the work *grows* as instances get bigger.
- **"If there's no certificate, something is broken."** Many instances are "no" instances. The
  Subset Sum instance `({2,4},5)` has no subset that adds to 5, and that is a correct answer, not
  an error.
- **"The problem and its instance format are the same thing."** The format is only how Redux
  writes instances down. The same problem could be written many other ways.

## How Redux shows it

- On [redux.isu.edu][redux-site], the **Problem** row picks a problem and fills in its default
  instance. Edit the text box to make your own instance.
- The ⓘ button next to a problem shows its definition.
- The API gives each problem's `defaultInstance`, `instanceFormat`, and `certificateFormat`. See
  [`info`](../reference/api.md#problem-provider).

## Further reading

- M. R. Garey and D. S. Johnson, *Computers and Intractability: A Guide to the Theory of
  NP-Completeness* (1979), chapter 2.
- [Decision problem](https://en.wikipedia.org/wiki/Decision_problem) on Wikipedia.
