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
- **Connect directly (Chrome/Edge, WebHID):** talks to the firmware over VIA's raw HID interface (usage page `0xFF60`), reads the live keymap and polls the switch matrix, like VIA's own tester. It also reads the RGB Matrix lighting (effect, color, brightness, speed) about once a second and shows it under the keys of the 3D model, with approximations of each effect. Needs HTTPS or localhost, and the VIA app has to be closed.

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
