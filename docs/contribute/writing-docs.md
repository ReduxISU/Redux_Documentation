---
description: How to write, check, and preview a page for the Redux documentation site.
sources:
  - Redux_Documentation:zensical.toml
  - Redux_Documentation:templates/**
  - Redux_Documentation:includes/**
---

# Writing docs

This page explains how to add or change a page on this site. Read it before you open a pull
request. It covers what kind of page to write, how to phrase it, how to check that every claim is
true, and what must never be published.

The site is built with [Zensical](https://zensical.org/docs/) from Markdown files in the
[`docs/` folder](https://github.com/ReduxISU/Redux_Documentation/tree/HEAD/docs) of the Redux_Documentation repository.

## Preview the site on your computer

=== "On your computer"

    You need [uv](https://docs.astral.sh/uv/getting-started/installation/). It installs the right
    Python and Zensical for you.

    ```bash
    git clone https://github.com/ReduxISU/Redux_Documentation.git
    cd Redux_Documentation
    uv sync
    uv run zensical serve
    ```

=== "In a devcontainer or Codespaces"

    The repository has a devcontainer that installs everything. In VS Code, open the folder and
    choose **Reopen in Container**. In Codespaces, create a codespace on `main`. From a terminal,
    run `devcontainer up --workspace-folder .`.

    Inside the container, start the preview so it can be reached from outside:

    ```bash
    uv run zensical serve -a 0.0.0.0:27300
    ```

Open <http://localhost:27300/Redux_Documentation/>. The page reloads each time you save a file.

Before you open a pull request, run the same build the site uses:

```bash
uv run zensical build --strict --clean
```

`--strict` stops the build if any link points at a page or heading that does not exist. Fix every
warning it prints.

## Get it merged and published

1. Push your branch and open a pull request to `main`.
2. The **`build-test / ci`** check runs the same strict build. If it fails, open the check's log,
   fix the warnings it lists, and push again.
3. Once the check passes and one person approves, you merge your own pull request.
4. The merge publishes the site that the check built. It is live within a few minutes.

For a one-line fix you can also use the **edit** button (:material-file-edit-outline:) at the top
right of any page, which opens the file on GitHub.

## Pick the kind of page

Every page is one of four kinds. Ask what the reader is trying to do:

| The reader wants to... | Write a | Example |
| --- | --- | --- |
| learn by doing, start to finish | **tutorial** | Your first reduction |
| get one task done | **how-to** | Add a verifier |
| look up a fact | **reference** | API error codes |
| understand why | **explanation** | What a reduction proves |

Don't mix kinds on one page. If a how-to starts explaining theory, move the theory into an
explanation page and link to it.

## Start from a template

Copy the matching file from the [`templates/` folder](https://github.com/ReduxISU/Redux_Documentation/tree/HEAD/templates) into `docs/`.

=== "Tutorial"

    ```markdown
    --8<-- "templates/tutorial.md"
    ```

=== "How-to"

    ```markdown
    --8<-- "templates/how-to.md"
    ```

=== "Reference"

    ```markdown
    --8<-- "templates/reference.md"
    ```

=== "Explanation"

    ```markdown
    --8<-- "templates/explanation.md"
    ```

## Fill in the front matter

Every page starts with two fields between `---` lines:

```yaml
---
description: How to add a verifier to an existing problem.
sources:
  - Redux:Documentation/guides/adding-a-verifier.md
  - Redux:Interfaces/VerifierInterface.cs
  - Redux:Problems/**/Verifiers/**
---
```

`description`
:   One sentence. It appears in search results and in the summaries that AI tools read.

`sources`
:   The code and files this page describes. Write each one as `<Repo>:<path>`, where the path
    can use `*` and `**`. When one of those files changes, this page probably needs to change too.
    Tools use this list to find the pages a code change affects, so keep it accurate when you edit.

## Add the page to the navigation

The menu is listed by hand in `nav` in [`zensical.toml`](https://github.com/ReduxISU/Redux_Documentation/blob/HEAD/zensical.toml). Add your page there in the
same pull request. A page that isn't in `nav` is hard to find.

## Write it plainly

- Write to the reader as "you", in the present tense.
- Use short sentences and common words. Many readers are new to the field, and some read English
  as a second language.
- Define a term the first time you use it.
- Use sentence case for headings ("Add a verifier", not "Add A Verifier"). Don't number
  headings. Numbers change when a section is inserted, and that breaks links to them.
- Show commands without a `$` prompt, so they copy cleanly. Show their output in a separate block.
- Use an admonition (`!!! note`, `!!! tip`, `!!! warning`) only for something the reader must not
  miss. Never put two in a row.
- When the steps differ by operating system, editor, or project, use content tabs (`=== "Linux"`).
- Give every picture and diagram a sentence of text that says the same thing.

Diagrams are written in [Mermaid](https://zensical.org/docs/authoring/diagrams/). Only flowchart,
sequence, state, class, and entity-relationship diagrams are supported.

## Link carefully

- **Between pages on this site**, use a relative link to the Markdown file:
  `[Writing docs](writing-docs.md)`. The strict build checks these links.
- **To the live site and the main repositories**, use the named links defined once in
  [`includes/links.md`](https://github.com/ReduxISU/Redux_Documentation/blob/HEAD/includes/links.md). Write `[redux.isu.edu][redux-site]` or `[Swagger][redux-swagger]`.
  If an address changes, it then changes in one place.
- **Never link to a page that hasn't been written yet.** Link to where the information lives
  today, usually a file in another repository, and change the link when the page moves here.

## Point at code the right way

Links into code go stale in two ways. Pick the link that fits the claim:

| You are pointing at | Use | Example |
| --- | --- | --- |
| a file or folder, in general | a branch link, with no line numbers | `https://github.com/ReduxISU/Redux/blob/HEAD/Program.cs` |
| specific lines, or proof of how something behaves | a permalink to one commit | `https://github.com/ReduxISU/Redux/blob/408f18ba/Program.cs#L84` |

`HEAD` always means the repository's default branch, so you don't need to know its name. Never
put `#L` line numbers on a `HEAD` link. The lines move and the link silently points at the wrong
code. Quote at most about 15 lines of code, directly under the permalink they came from.

When you do need a branch name, each repository has exactly one:

| Repository | Default branch |
| --- | --- |
| Redux | `CSharpAPI` |
| Redux_GUI | `ReduxAPI_GUI` |
| everything else | `main` |

## Check every claim

- **Run every command and do every step yourself** before you merge. In the pull request, say
  where you ran it (on [redux.isu.edu][redux-site], or locally).
- **Reference pages say what they were checked against.** Put the commit and date in the box at
  the top, as the reference template shows.
- **Avoid numbers that drift**, such as how many problems or tests exist. If a number matters, add
  "as of `<date>`" and say how to get the current value.
- **Describe only what is merged.** Work that is still in a pull request can appear only inside a
  `!!! note "Evolving"` box that links to that pull request.
- **Don't move a page that the code links to**, such as an error message pointing at the docs,
  without adding a redirect for its old address.

## Never publish

This site and its history are public, and deleting a line later does not remove it from git.
Never include:

- passwords, tokens, keys, or the contents of any `.env` file, even ones that look like examples.
  Use a placeholder like `<your-token>`.
- server details: host names other than the public addresses in `includes/links.md`, IP
  addresses, user accounts, `sudo` rules, service files, or paths on a server.
- anything about a student beyond what they have published themselves.
- criticism of a person, or of work that is still in progress.
- security problems that haven't been fixed.
- text copied from another project without its license notice.

When in doubt, summarize instead of copying, and ask in the pull request.

## Move a page from another repository

Much of this site starts as documentation that lives next to the code in other repositories.
When you move a page here:

1. Copy it faithfully first, so a reviewer can compare it with the original.
2. Change its links to code into `HEAD` links or permalinks, as described above.
3. Fix only the facts you have checked are out of date, and list them in the pull request.
4. Put the source repository and commit in the commit message, for example
   `Move adding-a-verifier.md from Redux@408f18ba`.
5. Restructure or rewrite it in a later pull request, not the same one.
