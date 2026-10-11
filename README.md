# npad configurator

A single-page configurator for the npad macropad (a [momokai Aurora](https://github.com/qmk/qmk_firmware/tree/master/keyboards/momokai/aurora) running QMK/VIA, USB ID `69F9:0009`). It shows a 3D model of the npad that reacts as you press keys and turn the knob, and once the npad is connected it remaps keys, edits macros and lighting, and saves or loads layouts.

No build step: `index.html` is the whole site. The Dockerfile only wraps it in nginx for deployment.

## Run locally

```sh
python3 -m http.server 8000
# open http://localhost:8000 in Chrome or Edge
```

## Deploy

The container serves the page on `$PORT` (8080 by default) and answers `GET /healthz` for health checks.

```sh
docker build -t npad-keytester . && docker run --rm -p 8080:8080 npad-keytester
```

## Connecting

**Connect npad** (Chrome or Edge) talks to the firmware over VIA's raw HID interface (usage page `0xFF60`). It needs HTTPS or localhost, and the VIA app has to be closed. Once allowed, the npad reconnects by itself on later visits.

Without a connection the page still works as a preview: the model idles on a slow orbit and reacts to keys that match the npad's stock keymap.

## Editing the npad

Opening the sidebar (it opens by itself on connect) switches to config mode: the model turns to a fixed, exploded view and each control gets a flag showing what it sends on the selected layer. Every change is written to the npad straight away, and ⌘Z undoes the last one.

- **Remap:** click a flag or a key on the model, then press the key or shortcut you want (⌘⇧S, F13…), or type to search every keycode by name ("vol", "play", "m2", "left click") and pick with ↑/↓ and Enter. Esc cancels.
- **Layer:** picks which of the 4 layers the flags show and edit. It also follows the npad: holding or tapping a layer key on the device switches it here. (Stock VIA firmware can't be told to change layers, so it only follows in that direction.)
- **Lighting:** effect, brightness, color, saturation and speed, saved to the npad as you change them. The model's backlight mirrors the firmware's effects.
- **Macros:** pick a macro from the row of tabs (or **+ Add macro**), then build it from steps: **Type** some text, **Press** a key or shortcut (click the keycap, then press it), **Wait** a number of milliseconds. Drag steps by their handle to reorder them. The header shows how much of the npad's macro storage (896 bytes) is used. Put a macro on a key by searching its name (M0, M1…) in that key's flag.
- **Event log:** presses and knob turns reported by the npad itself; other keyboards are ignored.
- **Restore** puts back the keymap, macros and lighting from when the npad connected. **Export** / **Import** use VIA's `.layout.json` format (keycode names, layers, knob and macros), so layouts move between this page and the VIA app.

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

- Knob turns aren't in the switch matrix, so the page only sees them if the browser receives the keys they send. macOS usually handles volume and mute keys before the browser does.
- The active layer can only be inferred from layer-key presses; the firmware doesn't report it over VIA.
