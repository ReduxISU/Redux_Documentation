---
description: How to type your own problem instance into Redux, with one example for each kind of problem.
sources:
  - Redux_GUI:components/pageblocks/ProblemRowReact.js
  - Redux_GUI:Tools/ProblemInstanceParser.js
  - Redux:Problems/**/*_Class.cs
---

# Write an instance

This page shows how to replace a problem's example instance with your own, such as your own
formula or graph. To learn what an instance is, see
[Problems and instances](../learn/problems-and-instances.md).

## Before you start

- Open [redux.isu.edu][redux-site] and choose your problem in the **Problem** row.
- Look at the example instance it loads. The quickest way to get the format right is to edit
  that example rather than start from nothing.

## Steps

1. Select the **Problem Instance** box and change the text.
2. Stop typing and wait a moment. The page reads the new instance and redraws the **Visualize**
   row.
3. Use the other rows (**Solve**, **Verify**, **Reduce**) as usual. They all work on the new
   instance.

To reuse an instance later, save it with the download button next to the box. You get a file
called `query.txt`. Load a saved one with the folder button.

## Check that it worked

The **Visualize** row redraws with your instance: your nodes, your clauses, or your sets. If it
still shows the old picture, the instance wasn't accepted. See [Common mistakes](#common-mistakes).

For five problems, the site checks the format as you type: **3SAT**, **Clique**, **Vertex
Cover**, **Graph Coloring**, and **Feedback Arc Set**. A bad instance turns the box's label red
and reads **Incorrect Format**, with an example to try underneath.

!!! warning "Other problems don't warn you yet"

    For every other problem, the site doesn't say when an instance is wrong. **Solve** just
    shows an empty answer. If that happens, compare your instance with the examples below, or
    with the problem's example instance, character by character.

## The building blocks

Instances are built from a few pieces, nested inside each other:

| Write | Means | Order matters? |
| --- | --- | --- |
| `{a,b,c}` | a set | no |
| `(a,b,c)` | a sequence of parts | yes |
| `{a,b}` inside an edge list | an undirected edge between a and b | no |
| `(a,b)` inside an edge list | a directed edge from a to b | yes |
| `({a,b},5)` | an edge with weight 5 | |

Names of nodes and elements can be numbers, letters, or words, including words with spaces such
as `New York`. Use the same name every time you mention the same thing.

## One example for each kind of problem

=== "Numbers and sets"

    | Problem | Example | Read it as |
    | --- | --- | --- |
    | Subset Sum | `({1,7,12,15},28)` | numbers, then a target |
    | Partition | `{3,5,7,8,9,10}` | the numbers to split |
    | Set Cover | `({1,2,3,4,5},{{1,2,3},{2,4},{3,4},{4,5}},3)` | the items, the sets to choose from, and how many sets you may use |

=== "Graphs"

    | Problem | Example | Read it as |
    | --- | --- | --- |
    | Clique | `(({a,b,c,d},{{a,b},{b,c},{a,c},{c,d}}),3)` | `((nodes, edges), k)` with undirected edges |
    | Hamiltonian Cycle | `({1,2,3,4},{{1,2},{2,3},{3,4},{4,1}})` | `(nodes, edges)` with no *k* |
    | Feedback Arc Set | `(({a,b,c},{(a,b),(b,c),(c,a)}),1)` | directed edges, written `(from,to)` |
    | Minimum Spanning Tree | `({1,2,3},{({1,2},4),({2,3},2),({1,3},5)})` | weighted edges, written `({u,v},weight)` |

    Problems that ask about a number *k*, such as Clique, Vertex Cover, and Independent Set,
    wrap the graph in its own parentheses and put *k* after it. Problems with no *k*, such as
    Hamiltonian Cycle, are just `(nodes, edges)`.

=== "Formulas"

    SAT and 3SAT take a formula in CNF: clauses joined by `&`, the literals in a clause joined
    by `|`, and `!` for "not". 3SAT allows at most three literals per clause. SAT allows any
    number.

    ```text
    (x1 | x2 | x3) & (!x1 | !x2 | !x3)
    ```

    ```text
    (x1 | x2 | x3 | x4) & (!x1 | !x2)
    ```

=== "Other"

    | Problem | Example | Read it as |
    | --- | --- | --- |
    | Prime Factorization | `15` | the number to factor |
    | N-Queens | `8` | the board size |
    | Edit Distance | `(horse, ros)` | the two words to compare |
    | Deutsch | `(0,1)` | the hidden function's outputs for 0 and 1 |
    | Deutsch–Jozsa | `(1,1,1,1)` | the hidden function's output for every input |

The exact format of any problem is in its `instanceFormat`, which the API's
[`info`](../reference/api.md#problem-provider) route returns.

## Common mistakes

| You wrote | What's wrong | Write instead |
| --- | --- | --- |
| <code>(x1 &#124; x2 &#124; x3 &#124; x4)</code> for 3SAT | 3SAT allows at most three literals per clause | split the clause, or use SAT |
| `(({a,b,c},{{a,d}}),2)` | the edge mentions `d`, which isn't in the node set | add `d` to the nodes |
| `((a,b,c),{{a,b}},2)` | the nodes are in `( )` and the graph isn't wrapped | `(({a,b,c},{{a,b}}),2)` |
| `{(a,b),(b,c)}` for an undirected graph | `( )` makes the edges directed | `{{a,b},{b,c}}` |
| `x1 OR x2` | words aren't understood | <code>(x1 &#124; x2)</code> |

## Related

- [The workbench](workbench.md) describes every control in the Problem row.
- [API errors](../reference/errors.md#instance_parse_error) explains the API's message when an
  instance can't be read.
