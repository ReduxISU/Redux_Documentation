---
description: How to run and test Redux_VR, the prototype 3D and VR view of reductions, and what it doesn't have yet.
sources:
  - Redux_VR:README.md
  - Redux_VR:package.json
  - Redux_VR:packages/**
  - Redux_VR:playground/**
  - Redux_VR:tools/**
  - Redux_VR:fixtures/**
---

# Redux_VR

[Redux_VR][repo-vr] is a **prototype** third way to see a reduction, after the website's flat
pictures. It draws both sides of a reduction in 3D, in the same scene, with lines that show which
part of one became which part of the other. It works in a browser, and in a VR headset through
WebXR. It is built with [React Three Fiber](https://r3f.docs.pmnd.rs/) and talks to the Redux API
directly from the browser.

- **Default branch:** `main`
- **Port:** 5173, the development server
- **Check:** none yet
- **Node:** 26

The steps every repository shares are in [How to contribute](index.md). Redux_VR doesn't have all
of them yet.

!!! warning "Not yet like the other repositories"

    As of 2026-11-07, `main` has **no devcontainer and no check on pull requests**. Nothing runs
    your tests for you, so run them yourself before you open a pull request. Work on a devcontainer
    and an rbs check exists on the `redux-k12` branch, which hasn't been merged.

## Run it

```bash
nvm use 26
npm install
npm run dev
```

Open <http://localhost:5173>. The development server listens on all network interfaces, so under
WSL a browser on Windows reaches it at the same address.

!!! warning "It uses the live site's API unless you say otherwise"

    By default Redux_VR calls the API at redux.isu.edu. For development, point it at a local API
    with `VITE_REDUX_BASE_URL`, or use the saved data, which needs no API at all.

=== "A local API"

    ```bash
    docker run -d --name redux-api -p 27000:27000 ghcr.io/reduxisu/redux:latest
    VITE_REDUX_BASE_URL=http://localhost:27000 npm run dev
    ```

    The value is read when the development server starts, so restart it after changing it.

=== "Saved data, no API"

    Open <http://localhost:5173/?source=fixtures>. The scene uses the API responses saved in
    `fixtures/` instead of calling the API.

### Useful addresses

| Add to the address | Effect |
| --- | --- |
| `?reduction=<className>` | Which reduction to show. The default is `SipserReduceToCliqueStandard`. |
| `?mode=reduction`, `gadgets`, or `solution` | Which correspondences to draw |
| `?menu=open` | Start with the reduction menu open |
| `?source=fixtures` | Use the saved data instead of the API |
| `?static=1` | Freeze the animation, for screenshots you can compare |

## Test it

| Command | What it checks |
| --- | --- |
| `npm test` | The unit tests, with vitest. They need no browser and no graphics card. |
| `npm run lint` | Code problems, with ESLint |
| `npm run format:check` | Formatting, with Biome. `npm run format` fixes it. |
| `npm run shoot [name]` | Takes a screenshot of the running development server, into `shots/` |

The layout code in `packages/layout/` turns a reduction into positions, without any 3D drawing.
That is what makes it testable without a browser. ESLint enforces the separation: importing
`three` or `react`, or touching `window` or `document`, from that package is a lint error.

### Refresh the saved data

`tools/capture-fixtures.ts` downloads fresh API responses into `fixtures/`. It also defaults to the
live site, so give it a local API:

```bash
node tools/capture-fixtures.ts --base=http://localhost:27000
```

## Try it in VR

`localhost` counts as a secure origin, so WebXR works there without certificates. Select **Enter
VR** at the top right. Without a headset, the
[Immersive Web Emulator](https://chromewebstore.google.com/detail/immersive-web-emulator/cgffilbpcibhmcfbgggfhfolhkfbhmik)
browser extension fakes one, with controllers.

What has been checked so far:

| Checked by | What |
| --- | --- |
| tests | The flat view, headset detection, the **Enter VR** button, and scene placement |
| the emulator | Starting a VR session, drawing for each eye, and controller rays hitting the menu |
| nobody yet | Whether depth helps students read the graph, comfort, text size in a headset, and frame rate |

The last row is the question this project exists to answer, and it needs a real headset. The
browser on a Quest headset supports WebXR. To reach your development server from one, connect it
by USB and run `adb reverse tcp:5173 tcp:5173`, which keeps the secure `localhost` address.
