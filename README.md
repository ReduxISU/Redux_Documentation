# Redux Documentation

Documentation for humans and machines on [Redux](https://redux.isu.edu/), Idaho State
University's interactive knowledgebase of canonical computer science problems, solutions, and
reductions.

**Site:** <https://reduxisu.github.io/Redux_Documentation/>

The site is built with [Zensical](https://zensical.org/docs/) from the Markdown in `docs/`.

## Preview

Requires [uv](https://docs.astral.sh/uv/getting-started/installation/).

```bash
uv sync
uv run zensical serve
```

Then open <http://localhost:27300/Redux_Documentation/>.

In the devcontainer (`.devcontainer/`, also used by Codespaces), run
`uv run zensical serve -a 0.0.0.0:27300` instead, so the published port can reach the server.

## Build

```bash
uv run zensical build --strict --clean
```

The output goes to `site/`. `--strict` fails on broken internal links and anchors.

Every pull request runs this build as the `build-test / ci` check. A merge to `main` publishes
the exact site that check built to GitHub Pages.

## Layout

| Path | What it holds |
| --- | --- |
| `docs/` | The pages |
| `templates/` | Starting points for each kind of page |
| `includes/links.md` | Named links to live sites and repositories, appended to every page |
| `zensical.toml` | Site configuration, including the navigation |

## Contributing

Read [Writing docs](docs/contribute/writing-docs.md) before opening a pull request.

## License

[BSD 3-Clause](LICENSE).
