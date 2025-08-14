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
