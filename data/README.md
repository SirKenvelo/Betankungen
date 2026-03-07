# Data Assets
**Stand:** 2026-03-07

## `dev_messages.b64`

- Zweck: entkoppelte Sammlung optionaler Developer-/Easter-Egg-Messages.
- Format: eine base64-kodierte Message pro Zeile.
- Hinweis: base64 ist Obfuskation, keine Verschluesselung.

## Pflege

- Encode-Helfer: `scripts/dev_messages_encode.sh`
- Input-Format fuer den Helfer:
  - Messages werden durch eine Zeile `---` getrennt.
  - Multi-Line-Messages sind erlaubt.
