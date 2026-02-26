return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("plugins.configs.lspconfig") -- NvChad base
      local lspconfig = require("lspconfig")

      -- HTML
      lspconfig.html.setup({})

      -- CSS
      lspconfig.cssls.setup({})

      -- JavaScript / TypeScript
      lspconfig.tsserver.setup({})

      -- Emmet
      lspconfig.emmet_ls.setup({
        filetypes = {
          "html",
          "css",
          "javascript",
          "javascriptreact",
          "typescriptreact",
        },
      })
    end,
  },
}

