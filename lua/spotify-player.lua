local M = {}

function M.setup(opts)
  opts = opts or {}
  require("spotify-player.window").setup(opts)
end

return M
