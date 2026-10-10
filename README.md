# npad Key Tester

A single-page key tester for the npad macropad (a [momokai Aurora](https://github.com/qmk/qmk_firmware/tree/master/keyboards/momokai/aurora) running QMK/VIA, USB ID `69F9:0009`). Press each key and turn the knob; each control lights up and turns green once the page registers it.

No build step: `index.html` is the whole site. The Dockerfile only wraps it in nginx for deployment.

## Run locally

```sh
python3 -m http.server 8000
# open http://localhost:8000 in Chrome or Edge
```

## Deploy (ngrok Ship)

Ship builds the `Dockerfile` on each push to `main`. The container serves the page on `$PORT` (8080 by default) and answers `GET /healthz` for the health check.

```sh
docker build -t npad-keytester . && docker run --rm -p 8080:8080 npad-keytester
```

## Two ways it listens

- **Key events (any browser):** matches what the npad types against the stock keymap below. You can remap controls in the page with "Set up keys" or by clicking a key, and the mapping is saved in the browser.
- **Connect npad (Chrome/Edge, WebHID):** talks to the firmware over VIA's raw HID interface (usage page `0xFF60`), reads the live keymap and polls the switch matrix, like VIA's own tester. It also reads the RGB Matrix lighting (effect, color, brightness, speed) about once a second and shows it under the keys of the 3D model, with approximations of each effect. Needs HTTPS or localhost, and the VIA app has to be closed.

## Editing the npad

With the npad connected, opening the sidebar switches to config mode: the model turns to a fixed view and each control gets a flag showing what it sends on the selected layer, with a dot that turns green once that control has registered.

- **Remap:** click a flag (or a key on the model). Press the key or shortcut you want (⌘⇧S, F13…), or type to search every keycode by name ("vol", "play", "macro 2", "left click") and pick with ↑/↓ and Enter. Esc cancels. Each change is written to the npad straight away. The sidebar has the layer switch, **Undo** (reverts the last change), **Restore** (puts back what was on the npad when it connected), **Save file** / **Load file** and **Clear tested**.
- **Macros** (sidebar): 16 macros made of steps (type text, press a key or shortcut, hold, release, wait), saved to the npad as you edit. Assign one to a key from the Macros group in the picker.

**Save file** / **Load file** use VIA's `.layout.json` format (keycode names, layers, knob and macros), so layouts move between this page and the VIA app.

## Stock keymap (layer 0)

| Control | Matrix | Sends |
|---|---|---|
| n | 1,0 | `Z` |
| Globe | 1,1 | `X` |
| Arrow | 1,2 | `C` |
| Shrimp | 2,0 | `` ` `` |
| Sailboat | 2,1 | `Esc` |
| Sparkle | 2,2 | `F2` |
| Knob press | 0,1 | Mute |
| Knob right / left | encoder 0 | Volume up / down |

## Known limits

- macOS usually handles the volume and mute keys before the browser gets them. Direct mode still sees the knob press, but encoder turns aren't in the switch matrix, so they only register if the browser receives the volume keys.
- Direct mode only reads from the device (keymap and matrix state). It never writes to it.
