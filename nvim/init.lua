require "core"

local custom_init_path = vim.api.nvim_get_runtime_file("lua/custom/init.lua", false)[1]

if custom_init_path then
  dofile(custom_init_path)
end

require("core.utils").load_mappings()

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

-- bootstrap lazy.nvim!
if not vim.loop.fs_stat(lazypath) then
  require("core.bootstrap").gen_chadrc_template()
  require("core.bootstrap").lazy(lazypath)
end

dofile(vim.g.base46_cache .. "defaults")
vim.opt.rtp:prepend(lazypath)
require "plugins"

vim.api.nvim_create_user_command("Delc", function()
  local count = vim.fn.searchcount({ pattern = "//", maxcount = 10000 }).total
  if count == 0 then
    print("No matches found.")
    return
  end
  vim.cmd("normal! gg n ") -- Start at the top
  for _ = 1, count do
    vim.cmd("normal! d$ n")
  end
end, {})

vim.cmd [[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
]]

-- Make line numbers visible
vim.cmd [[highlight LineNr guifg=#FFFFFF ctermfg=White gui=bold]]
vim.cmd [[highlight CursorLineNr guifg=#FFDD00 ctermfg=Yellow]]
vim.cmd [[highlight Comment guifg=#00FF00 ctermfg=Green]]




vim.diagnostic.config({
  virtual_text = false,  -- disable inline error messages
  float = {
    source = "always",   -- show source in float
    border = "rounded",
    focusable = true,
    header = "",
    prefix = "",
    wrap = true,         -- <- enables wrapping inside the float
  },
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins (Flutter + essentials)
require("lazy").setup({
  {
    "akinsho/flutter-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
    },
    config = function()
      require("flutter-tools").setup({
        ui = { border = "rounded" },
        debugger = { enabled = true },
        widget_guides = { enabled = true },
        dev_log = { enabled = true, open_cmd = "tabedit" },
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },

  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
})

-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- plugins
require("lazy").setup({
  {
    "akinsho/flutter-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
    },
    config = function()
      require("flutter-tools").setup({
        ui = { border = "rounded" },
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },

  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
})

-- basic LSP + completion (flutter-tools handles dartls for you)
local cmp = require("cmp")
cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = {
    { name = "nvim_lsp" },
  },
})

-- Optional keymaps for Flutter
vim.keymap.set("n", "<leader>fr", ":FlutterRun<CR>")
vim.keymap.set("n", "<leader>fh", ":FlutterReload<CR>")
vim.keymap.set("n", "<leader>fR", ":FlutterRestart<CR>")
vim.keymap.set("n", "<leader>fd", ":FlutterDevices<CR>")
vim.keymap.set("n", "<leader>ft", ":FlutterDevTools<CR>")
