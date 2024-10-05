# matchme.nvim

This plugin visually highlights the matching string(s) in the current buffer when selecting text in character visual mode.

## Installation

## [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
    "skazio/matchme.nvim"
}
```

## Documentation

See `:help matchme.nvim`, or `skazio/matchme.nvim/doc/matchme.txt`

## Known issues

The `.` character matches every character in the buffer.

## Limits

The visual matching doesn't work with:

- visual line mode
- visual block mode
