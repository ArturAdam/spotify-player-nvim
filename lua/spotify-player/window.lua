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

  -- If the window exists but is invalid, reset the handles
  if spotify_win and not api.nvim_win_is_valid(spotify_win) then
    spotify_win = nil
    spotify_buf = nil
  end

  -- Check if window already exists and is valid
  if spotify_win and api.nvim_win_is_valid(spotify_win) then
    -- If the window is valid, hide it
    api.nvim_win_hide(spotify_win)
  else
    -- Window doesn't exist, create it
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
          api.nvim_win_close(spotify_win, true)
          spotify_win = nil -- Reset the window handle
          spotify_buf = nil -- Reset the buffer handle
        end)
      end,
      once = true,
    })

    fn.termopen("spotify_player")

    -- Intercept the `q` key press to toggle window visibility
    api.nvim_buf_set_keymap(spotify_buf, "t", "q", "<CMD>SpotifyPlayer<CR>", { noremap = true, silent = true })

    vim.cmd("startinsert")
  end
end

function M.setup(opts)
  -- Create a command to toggle the window
  vim.api.nvim_create_user_command("SpotifyPlayer", create_spotify_player_window, {})
end

return M
