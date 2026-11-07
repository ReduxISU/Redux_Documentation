---
description: How to reduce a problem to another on redux.isu.edu, follow a chain of reductions, and find which problems a problem reduces to.
sources:
  - Redux_GUI:components/pageblocks/ReduceToRowReact.js
  - Redux_GUI:components/hooks/ProblemProvider/Reducer.js
  - Redux_GUI:pages/browse/**
  - Redux:AdditionalControllers/Navigation/Nav_Reductions.cs
---

# Reduce one problem to another

This page shows how to turn an instance of one problem into an instance of another with the
**Reduce** row, and how to find out what a problem can be reduced to. For why reductions matter,
see [Reductions](../learn/reductions.md).

## Before you start

- In the **Problem** row, choose the problem to reduce **from**, and set its instance.
  Reductions go one way. To reduce from Clique, Clique must be the problem in the top row.

## Steps

1. In the **Reduce** row, open **Select Problem To Reduce To**. The problems Redux can reach from
   yours are listed first. The rest are dimmed, because there is no chain of reductions to them.
2. Choose a target. **Select Reduction** fills in the way to get there. That is one reduction,
   or a chain of reductions joined with ` - `. For 3SAT to Vertex Cover it is *Sipser's Clique
   Reduction - Sipser's Vertex Cover Reduction*, which goes through Clique.
3. The reduction runs as soon as it is chosen. You don't need to select **Reduce**, which only
   runs it again.

## Check that it worked

The row shows the result, headed with the target's name, such as **Reduced Vertex Cover
Instance:** followed by the new instance. A SAT target shows its **Literals:** and clauses
instead.

To see the reduction rather than read it, go to the **Visualize** row and turn on **Show
reduction**. See [Step through a visualization](visualize.md#show-a-reduction).

## Find what a problem reduces to

The **Browse** page shows every problem as a card, with filters down the side.

1. Open **Browse** from the tabs at the top of the site.
2. Under **Reachable from**, choose a **Source problem**.
3. Pick **One reduction** for the problems one step away, or **Any reductions** for every
   problem reachable through a chain.
4. Select a card's title to open that problem on the home page.

From 3SAT, as of 2026-11-07, one reduction reaches 4 problems and any number of reductions
reaches 15.

The other filters narrow the cards by complexity class, problem type, solver type, solver
complexity, and visualization type. **Clear Filters** removes them all.

## Common mistakes

| You see | Why | What to do |
| --- | --- | --- |
| **Select Reduction** stays empty | You chose a dimmed target, so there's no reduction path to it | Choose a target from the top of the list, or check **Browse → Reachable from** |
| The problem you want to reduce *from* isn't offered | The **Reduce** row lists targets only | Change the problem in the **Problem** row instead |
| The reduced instance is huge | Reductions often make much bigger instances, which is normal | Use a smaller original instance |

## Related

- [Reductions](../learn/reductions.md) has the map of every reduction in Redux.
- [Redux API: discovery routes](../reference/api.md#discovery) can list reductions and find the
  cheapest chain.
