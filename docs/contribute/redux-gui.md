---
description: How to set up, run, and test Redux_GUI, the redux.isu.edu website, including pointing it at a local API and adding a new kind of visualization.
sources:
  - Redux_GUI:README.md
  - Redux_GUI:TESTING.md
  - Redux_GUI:.devcontainer/**
  - Redux_GUI:.env.example
  - Redux_GUI:package.json
  - Redux_GUI:rbs.toml
  - Redux_GUI:.github/workflows/**
  - Redux_GUI:pages/api/redux/[...path].js
  - Redux_GUI:components/Visualization/svgs/**
  - Redux_GUI:tests/**
---

# Redux_GUI

[Redux_GUI][repo-gui] is the website at [redux.isu.edu][redux-site]. It is a Next.js and React
app that draws problems with D3. It holds no problems of its own: every list, answer, and picture
comes from the [Redux API](redux/index.md).

- **Default branch:** `ReduxAPI_GUI`
- **Port:** 3000
- **Published image:** `ghcr.io/reduxisu/redux_gui`
- **Check:** `build-test / ci`, required

The steps every repository shares are in [How to contribute](index.md). This page covers what's
particular to the website.

## How it talks to the API

The browser never calls the API directly. It calls the website's own server, at
`/api/redux/...`, which passes each request on to the address in **`REDUX_BASE_URL`**. That is
the one setting that decides which API the website uses. It is read on every request, so one
built image can be pointed at any API when it starts.

## Open the devcontainer

The devcontainer has Node 26, rbs, Chromium for the browser tests, and access to Docker. It
publishes port 3000. It keeps `node_modules` and `.next` in their own volumes, so they never mix
with copies on your computer. Open it as described in
[Open the devcontainer](index.md#open-the-devcontainer).

!!! warning "Point it at a local API before you start"

    When the devcontainer is created, it copies `.env.example` to `.env.local`, and
    `.env.example` points at the **live site's API**. Edit `.env.local` to use a local API instead,
    as in the next section, so your work never touches the live site.

Two failures are common enough to know about:

- **Port 3000 is already in use.** Something else holds the port, such as an `npm run dev` left
  running. Find it with `docker ps --filter publish=3000`, and stop it.
- **A failed start leaves a broken container behind**, and the next attempt reuses it. The symptom
  looks like a network problem, such as `Could not resolve host`. Delete it and try again:

    ```bash
    docker rm -f $(docker ps -aq --filter "label=devcontainer.local_folder=$PWD")
    ```

## Run it against a local API

1. Start the API from its published image. This works the same from inside the devcontainer,
   because it uses your computer's Docker:

    ```bash
    docker run -d --name redux-api -p 27000:27000 ghcr.io/reduxisu/redux:latest
    ```

2. Tell the website where the API is, in `.env.local`:

    === "On your computer"

        ```text
        REDUX_BASE_URL=http://localhost:27000/
        ```

        You can also delete `.env.local`. The development default in `.env.development` is the
        same address.

    === "Devcontainer, Docker Desktop"

        Windows and Mac:

        ```text
        REDUX_BASE_URL=http://host.docker.internal:27000/
        ```

    === "Devcontainer, Linux"

        Including Docker on WSL without Docker Desktop:

        ```text
        REDUX_BASE_URL=http://172.17.0.1:27000/
        ```

        Inside a container, `localhost` is the container itself. `172.17.0.1` is your computer,
        as seen from Docker's default network.

3. Install and start the website:

    === "On your computer"

        Use Node 26. With nvm, run `nvm use 26` first.

        ```bash
        npm ci
        npm run dev
        ```

    === "In the devcontainer"

        The dependencies are already installed. Start it so it can be reached from outside the
        container:

        ```bash
        npm run dev -- -H 0.0.0.0
        ```

4. Open <http://localhost:3000>. It reloads as you edit. <http://localhost:3000/api/health>
   answers when the server is up.

To build and run the production image instead:

```bash
docker build -t redux-gui-local .
docker run -it --rm -p 3000:3000 -e REDUX_BASE_URL=http://host.docker.internal:27000/ redux-gui-local
```

Use the same `REDUX_BASE_URL` rules as above. Without it, every call the website makes to the API
fails.

## Test it

| Command | What it checks |
| --- | --- |
| `npm test` | The unit tests in `tests/unit/`, including the visualization coverage check below |
| `npm run check:visualizations` | That the visualization registry and the list of types agree |
| `npm run lint` | Code problems, with ESLint. `npm run lint:fix` fixes many of them. |
| `npm run format:check` | Formatting, with Biome. `npm run format` fixes it. |
| `npm run build` | That the site builds |
| `npm run test:e2e` | The browser tests, against a running website. See below. |

### The browser tests

The browser tests in `tests/e2e/` use [Playwright](https://playwright.dev/). They drive the real
website in a real browser against a real API. They don't start anything themselves. They test
whatever is at `RBS_BASE_URL`, `http://localhost:3000` by default.

**The full run, exactly what the check does:**

```bash
rbs integration-test
```

rbs builds the image, starts it next to the published API image, waits for both, runs the tests,
and removes everything. It's the slowest way, because it rebuilds the image each time.

**The fast loop, while you write a test.** Start a stack once, then re-run only the test you're
working on:

```bash
docker build -t local/redux_gui:ci .
docker network create redux-e2e
docker run -d --name e2e-redux --network redux-e2e ghcr.io/reduxisu/redux:latest
docker run -d --name e2e-gui --network redux-e2e -p 3101:3000 \
  -e REDUX_BASE_URL=http://e2e-redux:27000/ local/redux_gui:ci
export RBS_BASE_URL=http://localhost:3101

npx playwright test app.spec.js                 # one file
npx playwright test -g "solving 3SAT"           # one test, by name
npx playwright test --headed                    # watch it in a real window

docker rm -f e2e-redux e2e-gui && docker network rm redux-e2e
```

The container serves a compiled copy, so rebuild the image after changing app code. When a test
fails, open its trace with `npx playwright show-trace test-results/<test>/trace.zip`. It replays the
run, step by step.

### Why the tests watch every request

When a request to load data fails, the website writes a line to the browser console and carries on.
A broken API gives a page that merely looks empty. So `tests/e2e/fixtures.js` fails a test if any
request the page makes fails. Import `test` from `./fixtures`, not from `@playwright/test`, and
every test gets that guard.

The same file lists `KNOWN_SILENT_FAILURES`, requests that already fail on every page load today.
Each one is a real bug in the website. Fixing one means deleting its entry.

### Traps when writing tests

- **Don't use `getByLabel` for the dropdowns.** All six dropdowns share one element id, so every
  label points at the first one. Find the row by its title, then the `combobox` inside it, as the
  `row()` helper in `app.spec.js` does.
- **Solve and Verify start closed.** Select the row's ▼ button before you look inside.
- **Skip the icons when looking for a picture.** Every toolbar icon is an `<svg>` too. Use
  `svg:not(.MuiSvgIcon-root)`.
- **Use the names people see.** The problem `SAT3` is shown as *3SAT*, and `CLIQUE` as *Clique*.
- **The instance box waits about two seconds** before the rest of the page sees a change. Don't
  type into it unless the test is about it.

Each test in `tests/e2e/` is written to be copied, one per technique. The backlog of tests worth
adding is at the end of
[TESTING.md](https://github.com/ReduxISU/Redux_GUI/blob/HEAD/TESTING.md#backlog--good-first-contributions).

## What the check runs

Redux_GUI's `rbs.toml` uses the `npm` engine. Its check:

- **audits** the npm packages for known vulnerabilities;
- **checks formatting** with Biome, and **lints** with ESLint. Lint warnings are listed, but only
  errors fail the check;
- skips **typecheck**, because there's no `tsconfig.json`;
- runs **`npm test`**, the unit tests. There's no coverage minimum;
- **builds the image**, then **runs the browser tests** against it, with the published API image
  beside it;
- on a merge to `ReduxAPI_GUI`, **publishes** the image.

[The build system (rbs)](rbs.md) explains each step. The repository also runs CodeQL code
scanning, and a daily job that opens an issue if its list of visualization types drifts from the
API's. Neither blocks a pull request.

## Add a new kind of visualization

Most new visualizations need **no change here**. If an existing renderer can draw your picture
(graphs, sets, formulas, quantum circuits, tables, or pump schedules), the work is all in the API.
See [Adding a visualization](redux/adding-a-visualization.md).

You change this repository only for a **brand-new visualization type** that no renderer can draw:

1. **Write the renderer.** Add a React component to `components/Visualization/svgs/` that returns
   an SVG. It receives the API's data as props (`problemData`, plus `solve`, `url`, `gadgetMap`,
   and `gadgetsOn`), so it never calls the API itself. Start by copying a small renderer such as
   `StandardGraphSvgReact.js`.
2. **Register it** in `components/Visualization/svgs/Visualizations.js`, with one entry in the
   `Visualizations` map, keyed by the type's name:

    ```javascript
    ["GraphD3", renderGraphD3],
    ```

    Keep the key a double-quoted string at the start of the entry. The coverage check reads the
    file as text.
3. **Add the name** to `components/Visualization/svgs/visualizationTypes.json`, spelled exactly
   like the API's.
4. **Check it** with `npm run check:visualizations`.
5. **Open the matching API pull request** in Redux, and link the two to each other. Open this
   one first.

A new renderer is done when it draws both solved and unsolved instances, highlights gadgets when
it's used for a reduction, and follows the style of the existing renderers.

## Where things are

| Path | Holds |
| --- | --- |
| `pages/index.js` | The workbench, the home page |
| `pages/api/redux/[...path].js` | The server-side pass-through to the API |
| `components/pageblocks/` | The five rows: Problem, Visualize, Solve, Verify, Reduce |
| `components/widgets/` | Shared pieces, such as the dropdowns and the ⓘ box |
| `components/hooks/ProblemProvider/` | The state behind the rows |
| `components/redux/index.js` | Every call the website makes to the API |
| `components/Visualization/svgs/` | The renderers, and the registry that picks one |
| `tests/unit/`, `tests/e2e/` | The unit tests and the browser tests |

## Things that trip people up

- **Use Node 26.** The repository requires it. An older Node only prints a warning during
  install, but isn't supported.
- **`NEXT_PUBLIC_REDUX_REPO_URL` is fixed at build time.** It sets where the ⓘ box's source links
  go. Restart `npm run dev`, or rebuild the image, after changing it.
- **`.env.local` is yours.** Git ignores it, so your API address never ends up in a commit.
