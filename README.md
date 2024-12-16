
# spotify-player-nvim

Plugin for calling [spotify-player](https://github.com/aome510/spotify-player) from within neovim.
Inspired by [vi-mongo](https://github.com/kopecmaciej/vi-mongo.nvim)

## Requirements

- Neovim (0.5 or later)
- `spotify-player` CLI tool installed and available in your PATH

### Install

Install using [`lazy.nvim`](https://github.com/folke/lazy.nvim):
```
return {
  "ArturAdam/spotify-player-nvim",
  config = function()
    require("spotify-player").setup()
  end,
  cmd = { "SpotifyPlayer" },
  keys = {
    { "<leader>sp", "<cmd>SpotifyPlayer<cr>", desc = "SpotifyPlayer" },
  },
}
```
