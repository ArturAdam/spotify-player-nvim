local api = vim.api
local fn = vim.fn

local M = {}

local function create_spotify_player_window()
  if fn.executable("spotify_player") ~= 1 then
    api.nvim_err_writeln("Failed to start spotify-player. Is it installed and in your PATH?")
    return
  end

  local buf = api.nvim_create_buf(false, true)
  local width = vim.o.columns
  local height = vim.o.lines

  local win_height = math.ceil(height * 0.9)
  local win_width = math.ceil(width * 0.9)

  local row = math.ceil((height - win_height) / 2 - 1)
  local col = math.ceil((width - win_width) / 2)

  local opts = {
    style = "minimal",
    relative = "editor",
    width = win_width,
    height = win_height,
    row = row,
    col = col,
    border = "rounded",
  }

  local win = api.nvim_open_win(buf, true, opts)

  api.nvim_set_option_value("winblend", 0, { win = win })

  vim.bo[buf].bufhidden = "wipe"

  api.nvim_create_autocmd("TermClose", {
    buffer = buf,
    callback = function()
      vim.schedule(function()
        api.nvim_win_close(0, true)
      end)
    end,
    once = true,
  })

  fn.termopen("spotify_player")

  vim.cmd("startinsert")
end

function M.setup(opts)
  vim.api.nvim_create_user_command("SpotifyPlayer", create_spotify_player_window, {})
end

return M
