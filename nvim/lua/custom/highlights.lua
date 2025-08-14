-- lua/custom/highlights.lua
local M = {}

---@type HLTable
M.override = {
  -- Makes the background of NvimTree the same as Normal (or transparent if set)
  NvimTreeNormal = { bg = "NONE" },
  NvimTreeNormalNC = { bg = "NONE" },
  NvimTreeEndOfBuffer = { fg = "NONE", bg = "NONE" },
  NvimTreeVertSplit = { bg = "NONE", fg = "NONE" },

  -- Optional: make NvimTree borderless
  -- Transparent tabline
  TabLineFill = { bg = "NONE" },
  TabLine = { bg = "NONE", fg = "NONE" },
  TabLineSel = { bg = "NONE", fg = "NONE", bold = false },

  -- Optional: also make separator and winbar transparent
  WinSeparator = { fg = "NONE", bg = "NONE" },
  WinBar = { fg = "NONE", bg = "NONE" },
  WinBarNC = { fg = "NONE", bg = "NONE" },
}


M.add = {}

return M
