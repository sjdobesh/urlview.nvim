local M = {}

local utils = require("urlview.utils")
local config = require("urlview.config")

--- Use command to open the URL
---@param cmd string @name of executable to run
---@param args string|table @arg(s) to pass into cmd (unescaped URL string or table of args)
local function shell_exec(cmd, args)
  if cmd and vim.fn.executable(cmd) == 1 then
    -- NOTE: `vim.fn.system` shellescapes arguments
    local cmd_args = { cmd }
    vim.list_extend(cmd_args, type(args) == "table" and args or { args })
    local err = vim.fn.system(cmd_args)
    if vim.v.shell_error ~= 0 or err ~= "" then
      utils.log(
        string.format("Failed to navigate link with cmd `%s` and args `%s`\n%s", cmd, args, err),
        vim.log.levels.ERROR
      )
    end
  else
    utils.log(
      string.format("Cannot use command `%s` to navigate links (either empty or non-executable)", cmd),
      vim.log.levels.ERROR
    )
  end
end

--- Use `netrw` to navigate to a URL
---@param raw_url string @unescaped URL
function M.netrw(raw_url)
  local url = vim.fn.shellescape(raw_url)
  local ok, err = pcall(vim.cmd, string.format("call netrw#BrowseX(%s, netrw#CheckIfRemote(%s))", url, url))
  if not ok and vim.startswith(err, "Vim(call):E117: Unknown function") then
    -- lazily use system action if netrw is disabled
    M.system(raw_url)
  end
end

--- Use the user's default browser to navigate to a URL
--- this is never called?
---@param raw_url string @unescaped URL
function M.system(raw_url)
  local os = utils.os
  if os == "Darwin" then -- MacOS
    shell_exec("open", raw_url)
  elseif os == "Linux" or os == "FreeBSD" then -- Linux and FreeBSD
    shell_exec("xdg-open", raw_url)
  elseif os:match("Windows") then -- Windows
    -- HACK: `start` cmd itself doesn't exist but lives under `cmd`
    shell_exec("cmd", { "/C", "start", raw_url })
  else
    utils.log(
      "Unsupported operating system for `system` action. Please raise a GitHub issue for " .. os,
      vim.log.levels.WARN
    )
  end
end

--- Copy URL to clipboard
---@param raw_url string @unescaped URL
function M.clipboard(raw_url)
  vim.fn.setreg(config.default_register, raw_url)
  utils.log(string.format("URL %s copied to clipboard", raw_url), vim.log.levels.INFO)
end

local function feedkeys(keys, mode, escape_ks)
  local replaced_keys = vim.api.nvim_replace_termcodes(keys, true, true, escape_ks)
  vim.api.nvim_feedkeys(replaced_keys, mode, escape_ks)
end

-- for manually set action!
return setmetatable(M, {
  -- execute action as command if it is not one of the above module keys
  __index = function(_, k)
    if k ~= nil then
      return function(raw_url)
        local http_pattern = "https?://"
        local www_pattern = "www%."
        print(raw_url)
        if raw_url:match(http_pattern) or raw_url:match(www_pattern) then
          return shell_exec(k, raw_url)
        else
          vim.fs.normalize(raw_url) -- convert relative to absolute path
          if not vim.loop.fs_stat(raw_url) then
            print("couldn't find " .. raw_url)
            local newpath = raw_url:match("[.~]*/[%w/]+")
            local choice = vim.fn.confirm(newpath, "create file? &yes\n&no")
            if choice == 1 then
              feedkeys(":e " .. newpath .. "<cr>", "n", true)
            end
          else
            print("found " .. raw_url)
            feedkeys(":e " .. raw_url .. "<cr>", "n", true)
          end
        end
      end
    end
  end,
})
