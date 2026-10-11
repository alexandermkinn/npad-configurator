# npad configurator

A single-page configurator for the npad macropad (a [momokai Aurora](https://github.com/qmk/qmk_firmware/tree/master/keyboards/momokai/aurora) running QMK/VIA, USB ID `69F9:0009`). It shows a 3D model of the npad that reacts as you press keys and turn the knob, and once the npad is connected it remaps keys, edits macros and lighting, and saves or loads layouts.

Live at **https://npad.ngrok.dev**, deployed with ngrok Ship.

<img width="1624" height="1062" alt="Screenshot 2026-10-11 at 1 38 56 PM" src="https://github.com/user-attachments/assets/d410de81-e89e-40da-b33d-a417ba5b2538" />
<img width="1624" height="1062" alt="Screenshot 2026-10-11 at 1 38 40 PM" src="https://github.com/user-attachments/assets/1ae6697d-49c9-4150-9a1b-7c7bb8d02dae" />


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

**Connect npad** (Chrome or Edge) talks to the firmware over VIA's raw HID interface (usage page `0xFF60`). It needs HTTPS or localhost, and the VIA app has to be closed. Once allowed, the npad reconnects by itself on later visits and whenever it is plugged back in.

Without a connection the page still works as a preview: the model idles on a slow orbit and reacts to keys that match the npad's stock keymap.

## Editing the npad

Opening the sidebar switches to config mode (it opens by itself when you connect with the button or plug the npad in): the model turns to a fixed, exploded view and each control gets a flag showing what it sends on the selected layer. Every change is written to the npad straight away, and ⌘Z undoes the last one.

- **Remap:** click a flag or a key on the model, then press the key or shortcut you want (⌘⇧S, F13…), or type to search every keycode by name ("vol", "play", "m2", "left click") and pick with ↑/↓ and Enter. Esc cancels.
- **Layer:** picks which of the 4 layers the flags show and edit. It also follows the npad: holding or tapping a layer key on the device switches it here. (Stock VIA firmware can't be told to change layers, so it only follows in that direction.)
- **Lighting:** effect, brightness, color, saturation and speed, saved to the npad as you change them. The model's backlight mirrors the firmware's effects.
- **Macros:** pick a macro from the row of tabs (or **+ Add macro**), then build it from steps: **Type** some text, **Press** a key or shortcut (click the keycap, then press it), **Wait** a number of milliseconds. Drag steps by their handle to reorder them. The header shows how much of the npad's macro storage (896 bytes) is used. Put a macro on a key by searching its name (M0, M1…) in that key's flag.
- **Event log:** presses and knob turns reported by the npad itself; other keyboards are ignored.
- **Restore** puts back the keymap, macros and lighting from when the npad connected. **Export** / **Import** use VIA's `.layout.json` format (keycode names, layers, knob and macros), so layouts move between this page and the VIA app.

