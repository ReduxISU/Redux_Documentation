---
description: Every row, button, and field on the redux.isu.edu home page, and what each one does.
sources:
  - Redux_GUI:pages/index.js
  - Redux_GUI:components/pageblocks/**
  - Redux_GUI:components/widgets/**
  - Redux_GUI:components/tour/**
---

# The workbench

This page lists every part of the [redux.isu.edu][redux-site] home page. For a guided first use,
see [Your first session](first-session.md).

!!! info "Checked against the live site on 2026-11-06"

    Labels are quoted as the site shows them. The site is updated from time to time, so a label
    may change before this page does.

## Page layout

| Part | Where | What it does |
| --- | --- | --- |
| **Tabs** | Top of the page | **Home**, **About Us**, **Browse**, **Help**, **Contribute**. They're hidden on narrow screens. |
| **Theme button** | Top right | Switches between light and dark mode. |
| **Getting started** | Near the top left | Starts an 11-step guided tour of the workbench. After you finish it once, it becomes a small button that replays the tour. |
| **Share button** | Bottom right | Makes a link to the page. See [Share](#share). |
| **The five rows** | The middle of the page | **Problem**, **Visualize**, **Solve**, **Verify**, and **Reduce**, in that order. |

## Controls every row has

| Control | What it does |
| --- | --- |
| **The dropdown** | Picks what the row works with: a problem, solver, verifier, visualization, or reduction. Type in it to search. Each choice shows tags, such as its complexity class or problem type. |
| **ⓘ** | Opens a box describing the current choice. See [The ⓘ box](#the-i-box). |
| **⠿** (*Drag to reorder*) | Drag it to move the row up or down. The order resets when the page reloads. |
| **▼** | Opens or closes the row. **Solve** and **Verify** start closed. |

## The rows

### Problem

| Control | What it does |
| --- | --- |
| **Select problem** | The problem to work on. Choosing one loads its example instance. The page starts on **3SAT**. |
| Filter button | Narrows the problem list by **Complexity Class** and **Problem Type**. The number on it counts the filters in use. **Clear filters** removes them all. |
| **Problem Instance** | The instance as text. Edit it to try your own. See [Write an instance](instances.md). |
| Folder button | Loads an instance from a text file. |
| Download button | Saves the current instance as `query.txt`. |

### Visualize

| Control | What it does |
| --- | --- |
| **Select visualization** | Which picture to draw. A choice the site can't draw yet is greyed out. |
| **Refresh** | Goes back to the first frame and turns the switches off. |
| ⏮ ◀ *step* ▶ ⏭ | Steps through the frames: first, back, the current step number, forward, and last. |
| **Show reduction** | Draws the reduced problem beside the original. It needs a reduction chosen in the **Reduce** row. |
| **Highlight gadgets** | When on, pointing at a part of one side lights up the matching part of the other. |
| **Highlight solution** | Shows the solved picture, with the answer highlighted. With **Show reduction** on, the answer is highlighted on both sides. |

The row draws the current instance as soon as the page loads, using the visualization's own
solver. For what the pictures mean, see [Visualizations](../learn/visualizations.md).

### Solve

| Control | What it does |
| --- | --- |
| **Select Solver** | Which algorithm to run. The problem's default is chosen for you. |
| **Solve** | Runs the solver on the current instance and shows its answer after **Solution:**. |
| Download button | Saves the answer to a file. A very long answer is only available this way. |

### Verify

| Control | What it does |
| --- | --- |
| **Select verifier** | Which verifier checks the answer. |
| **Enter a certificate:** | The answer to check, written in the problem's certificate format. |
| **Verify** | Checks the certificate against the current instance. It shows **Verifier output: True** or **False**. |

If the certificate can't be read, the row says so and shows the expected format.

### Reduce

| Control | What it does |
| --- | --- |
| **Select Problem To Reduce To** | The target problem. |
| **Select Reduction** | How to get there: one reduction, or a chain of them joined with ` - `. |
| **Reduce** | Runs the reduction again. It also runs by itself as soon as a reduction is chosen. |
| Download button | Saves the reduced instance to a file. |

The result appears below the controls, for example **Reduced Clique Instance:** followed by the
new instance. For 3SAT, the page starts out reducing to **Clique** with **Sipser's Clique
Reduction**.

## The ⓘ box

The ⓘ box describes whatever the row has selected. Depending on what that is, it shows:

| Field | Shown for |
| --- | --- |
| **Input**, **Output**, **Definition** | Problems |
| **Complexity class** | Problems |
| **Solver type**, **Complexity bucket**, **Big-O** | Solvers |
| **Reduction cost**, reduction type, and growth rate | Reductions |
| **Source** | The paper or book it comes from |
| **Code** | A link to its source code on GitHub |
| **Contributed by** | The people who wrote it |

## Share

The share button builds a link that names the current problem, instance, solver, verifier, and
reduction. If your browser can share directly, it opens your device's share menu. Otherwise it
copies the link and shows *"Web Share API is not supported in your browser. The share URL has
been copied to your clipboard."*

!!! warning "Opening a shared link restores only the problem"

    Today the site reads only the problem from a shared link. The instance and the other choices
    go back to their defaults. To share a specific instance, send the instance text too, or
    download it with the Problem row's download button.

You can also link straight to a problem: `https://redux.isu.edu/?problem=CLIQUE` opens the
workbench on Clique. Use the problem's name as the API spells it, such as `SAT3`, `CLIQUE`, or
`VERTEXCOVER`. An unknown name opens 3SAT.
