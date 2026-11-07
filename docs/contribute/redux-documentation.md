---
description: How to preview this documentation site on your computer and get a change to it merged and published.
sources:
  - Redux_Documentation:zensical.toml
  - Redux_Documentation:.devcontainer/**
  - Redux_Documentation:.github/workflows/**
---

# Redux_Documentation

The [Redux_Documentation][repo-docs] repository holds this site. It is built with
[Zensical](https://zensical.org/docs/) from the Markdown files in its
[`docs/` folder](https://github.com/ReduxISU/Redux_Documentation/tree/HEAD/docs).

!!! note "Most pages will be kept up to date automatically"

    Pages here will mostly be updated automatically as the code they describe changes. Guidance
    for writing pages by hand will be published here once that is in place. Until then, small
    fixes are welcome. For anything bigger, ask on the [Discord][redux-discord] first.

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

1. Make a branch named for the kind of change and its issue, such as `docs/12-fix-install-steps`.
2. Push it and open a pull request to `main`. Write the title as a plain sentence saying what
   the change does.
3. The **`build-test / ci`** check runs the same strict build. If it fails, open the check's log,
   fix the warnings it lists, and push again.
4. Once the check passes and one person has approved, you or the reviewer can merge. Use
   **Squash and merge**.
5. The merge publishes the site that the check built. It is live within a few minutes.

For a one-line fix you can also use the **edit** button (:material-file-edit-outline:) at the top
right of any page, which opens the file on GitHub.
