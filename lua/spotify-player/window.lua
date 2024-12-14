local api = vim.api
local fn = vim.fn

local M = {}

local spotify_win = nil -- Store the window handle
local spotify_buf = nil -- Store the buffer handle

local function create_spotify_player_window()
  if fn.executable("spotify_player") ~= 1 then
    api.nvim_err_writeln("Failed to start spotify-player. Is it installed and in your PATH?")
    return
  end

  -- Check if window already exists
  if spotify_win then
    local win_visible = api.nvim_win_is_valid(spotify_win)
    if win_visible then
      -- If the window is visible, hide it
      api.nvim_win_hide(spotify_win)
    else
      -- If the window is hidden, show it again
      api.nvim_win_show(spotify_win)
    end
  else
    spotify_buf = api.nvim_create_buf(false, true)
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

    spotify_win = api.nvim_open_win(spotify_buf, true, opts)

    api.nvim_set_option_value("winblend", 0, { win = spotify_win })

    vim.bo[spotify_buf].bufhidden = "wipe"

    api.nvim_create_autocmd("TermClose", {
      buffer = spotify_buf,
      callback = function()
        vim.schedule(function()
          api.nvim_win_close(0, true)
        end)
      end,
      once = true,
    })

    fn.termopen("spotify_player")

    -- Intercept the `q` key press to toggle window visibility
    api.nvim_buf_set_keymap(spotify_buf, "t", "q", "<Cmd>ToggleSpotifyPlayer<CR>", { noremap = true, silent = true })

    vim.cmd("startinsert")
  end
end

function M.setup(opts)
  vim.api.nvim_create_user_command("ToggleSpotifyPlayer", create_spotify_player_window, {})
end

return M
