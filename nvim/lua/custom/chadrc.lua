---@type ChadrcConfig
local M = {}

M.ui = {
  theme = "ashes", -- or your preferred theme
  transparency = true,  -- this enables transparent background generally
  tabufline = {
    enabled = false,
  }, hl_override = require("custom.highlights").override,
}

M.plugins = "custom.plugins"

return M
