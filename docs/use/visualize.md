---
description: How to pick a visualization, step through its frames, and show a reduction side by side.
sources:
  - Redux_GUI:components/pageblocks/VisualizeRowReact.js
  - Redux_GUI:components/Visualization/**
  - Redux:Interfaces/VisualizationInterface.cs
---

# Step through a visualization

This page shows how to use the **Visualize** row: choose a picture, step through it, and draw a
reduction beside its original. For what the pictures mean, see
[Visualizations](../learn/visualizations.md).

## Before you start

- Choose a problem in the **Problem** row. The **Visualize** row opens already drawing its
  instance.

## Steps

1. **Choose a picture.** Open **Select visualization**. Some problems have more than one. Clique
   can be drawn as **Clique Visualization** or **Clique LaTeX Visualization**. Single Source
   Shortest Path can be drawn as a graph or as a table.
2. **Step through the frames** with the buttons next to **Refresh**:

    | Button | Goes to |
    | --- | --- |
    | ⏮ | the first frame, the instance as given |
    | ◀ | the previous frame |
    | *(number)* | shows which frame you are on, counting from 0 |
    | ▶ | the next frame |
    | ⏭ | the last frame, the solved picture |

3. **Jump to the answer.** Turn on **Highlight solution** to go straight to the solved picture.
   It also turns on by itself when you step to the last frame.
4. **Start over.** **Refresh** goes back to the first frame and turns all three switches off.

## What the frames show

How many frames there are depends on the visualization:

- **Most graph problems** have two: the instance, then the solved picture with the answer
  highlighted. Clique and Vertex Cover work this way.
- **Some show the whole search.** Try **Single Source Shortest Path**. Its seven frames show the
  algorithm working outward from the start node. Colors mark the node and edge being examined
  and the shortest paths found so far. The DFA, NFA, and Pump Scheduling visualizations also step
  through their work.

The API also gives each step a one-line caption. The website doesn't show those captions yet.

## Show a reduction

1. In the **Reduce** row, choose a problem to reduce to. See
   [Reduce one problem to another](reduce.md).
2. In the **Visualize** row, turn on **Show reduction**. The original is drawn on the left and the
   reduced problem on the right.
3. Turn on **Highlight gadgets**, then point at a part of either picture. The matching parts of
   the other side light up.
4. Turn on **Highlight solution** to see the answer on both sides at once.

[Your first session](first-session.md) walks through this for 3SAT and Clique.

## Check that it worked

The frame number changes as you step, and the picture changes with it. With **Show reduction**
on, there are two pictures, separated by a bar you can drag.

## Common mistakes

| You see | Why | What to do |
| --- | --- | --- |
| **Show reduction** is greyed out | The problem has no reductions, or none is chosen in the **Reduce** row | Choose a reduction first. Some problems, such as shortest paths, have none. |
| **Highlight gadgets** does nothing | You need to point at a part of the picture. Also, not every reduction records its gadgets. | Hover over a node or clause. Try 3SAT to Clique, which records them. |
| The dropdown says *No renderable visualization for this problem* | Nobody has written a picture for this problem yet | Use **Solve** and **Verify**, which still work. |
| The picture didn't change after you edited the instance | The new instance wasn't accepted | See [Write an instance](instances.md#check-that-it-worked). |
| ▶ and ⏭ do nothing | You are on the last frame already | Most graph problems have only two frames. |

## Related

- [Visualizations](../learn/visualizations.md) explains frames, steps, and gadgets.
- [The workbench](workbench.md#visualize) lists every control in the row.
