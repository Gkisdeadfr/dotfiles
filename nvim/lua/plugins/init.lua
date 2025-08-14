-- plugins have lazy=true by default,to load a plugin on startup just lazy=false
-- List of all default plugins & their definitions
local default_plugins = {
  { "nvim-lua/plenary.nvim" },

  -- {
  --   "NeogitOrg/neogit",
  --   dependencies = "nvim-lua/plenary.nvim",
  --   config = function()
  --     require("neogit").setup()
  --   end,
  --   keys = {
  --     { "<leader>gg", function() require("neogit").open() end, desc = "Neogit" },
  --   },
  -- },

  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup {}
    end,
  },

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",  -- new harpoon
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()

      require("telescope").load_extension("harpoon")
    end
  },


  {
    "kylechui/nvim-surround",
    version = "*", -- Use the latest stable version
    event = "VeryLazy", -- Lazy load when needed
    config = function()
      require("nvim-surround").setup({})
    end,
  }, 

  { "folke/tokyonight.nvim"},

  {
    "tpope/vim-fugitive",
  },
  { "glacambre/firenvim",
    lazy = false,
    build = ":call firenvim#install(0)"
  },

  {
    "olrtg/nvim-emmet",
    lazy = false,
    config = function()
      vim.keymap.set({ "n", "v" }, "<leader>ce", require("nvim-emmet").wrap_with_abbreviation)
    end,
  },

  {
    "mfussenegger/nvim-lint",
    init = function()
      local lint = require "lint"
      lint.linters_by_ft = {
        python = { "flake8" },
        -- Add other filetypes and their linters as needed
      }

      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },

  {
    "NvChad/base46",
    branch = "v2.0",
    build = function()
      require("base46").load_all_highlights()
    end,
  },

  {
    "NvChad/ui",
    branch = "v2.0",
    lazy = false,
  },

  {
    "zbirenbaum/nvterm",
    init = function()
      require("core.utils").load_mappings "nvterm"
    end,
    config = function(_, opts)
      require "base46.term"
      require("nvterm").setup(opts)
    end,
  },

  {
    "NvChad/nvim-colorizer.lua",
    event = "User FilePost",
    config = function(_, opts)
      require("colorizer").setup(opts)

      -- execute colorizer as soon as possible
      vim.defer_fn(function()
        require("colorizer").attach_to_buffer(0)
      end, 0)
    end,
  },

  {
    "nvim-tree/nvim-web-devicons",
    opts = function()
      return { override = require "nvchad.icons.devicons" }
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "devicons")
      require("nvim-web-devicons").setup(opts)
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    version = "2.20.7",
    event = "User FilePost",
    opts = function()
      return require("plugins.configs.others").blankline
    end,
    config = function(_, opts)
      require("core.utils").load_mappings "blankline"
      dofile(vim.g.base46_cache .. "blankline")
      require("indent_blankline").setup(opts)
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    opts = function()
      return require "plugins.configs.treesitter"
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "syntax")
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- git stuff
  {
    "lewis6991/gitsigns.nvim",
    event = "User FilePost",
    opts = function()
      return require("plugins.configs.others").gitsigns
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "git")
      require("gitsigns").setup(opts)
    end,
  },

  -- lsp stuff
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
    opts = function()
      return require "plugins.configs.mason"
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "mason")
      require("mason").setup(opts)

      -- custom nvchad cmd to install all mason binaries listed
      vim.api.nvim_create_user_command("MasonInstallAll", function()
        if opts.ensure_installed and #opts.ensure_installed > 0 then
          vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
        end
      end, {})

      vim.g.mason_binaries_list = opts.ensure_installed
    end,
  },

  {
    "neovim/nvim-lspconfig",
    lazy = false,
    event = "User FilePost",
    config = function()
      local lsp_user_configs = require "plugins.configs.lspconfig"
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require "lspconfig"
      local util = require "lspconfig/util"
      --
      --     lspconfig.svelte.setup { capabilities = capabilities }
      -- lspconfig.biome.setup{ capabilities = capabilities }
      lspconfig.lua_ls.setup { capabilities = capabilities }
      lspconfig.ts_ls.setup { capabilities = capabilities }
      -- lspconfig.ltex.setup { capabilities = capabilities }
      lspconfig.texlab.setup { capabilities = capabilities }
      lspconfig.csharp_ls.setup { capabilities = capabilities }
      lspconfig.cmake.setup { capabilities = capabilities }
      lspconfig.verible.setup {
        capabilities = capabilities,
        on_attach = lsp_user_configs.on_attach,
        filetypes = { "verilog", "systemverilog" },
        root_dir = function(fname)
          return util.root_pattern(".git")(fname) or util.path.dirname(fname)
        end,
      }
      --     lspconfig.marksman.setup { capabilities = capabilities }
      --     lspconfig.pyre.setup { capabilities = capabilities }
      --     lspconfig.pylsp.setup { capabilities = capabilities }
          lspconfig.emmet_language_server.setup {}
      --     lspconfig.rust_analyzer.setup {
      --       on_attach = function(client, bufnr)
      --         vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      --       end,
      --       settings = {
      --         ["rust-analyzer"] = {
      --           imports = {
      --             granularity = {
      --               group = "module",
      --             },
      --             prefix = "self",
      --           },
      --           cargo = {
      --             buildScripts = {
      --               enable = true,
      --             },
      --           },
      --           procMacro = {
      --             enable = true,
      --           },
      --         },
      --       },
      --     }
      --
      --     lspconfig.csharp_ls.setup { capabilities = capabilities }
      lspconfig.clangd.setup {
        cmd = { "clangd", "--query-driver=/usr/bin/c++", "--compile-commands-dir=build" }, -- Default clangd command

        -- Filetype-specific configuration
        filetypes = { "cpp", "c", "objc", "objcpp", "cuda", "js"},
        on_attach = function(client, bufnr)
          -- Apply C++17 flag only for C++ files
          if vim.bo.filetype == "cpp" then
            client.notify("workspace/didChangeConfiguration", {
              settings = {
                clangd = {
                  cmd = { "clangd", "--query-driver=/usr/bin/c++" },
                },
              },
            })
          end
        end,
        capabilities = capabilities,
      }
      --     lspconfig.cssls.setup { capabilities = capabilities }
      --     lspconfig.html.setup { capabilities = capabilities }
      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {})
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup {
        ensure_installed = {
          -- "rust_analyzer",
          -- "ast-grep",
          "lua_ls",
          "ts_ls",
          "texlab",
          "verible",
          -- "marksman",
          -- "pyre",
          -- "pylsp",
          -- "csharp_ls",
          "clangd",
          -- "cssls",
          -- "svelte",
          -- "html",
        },
        automatic_installation = true,
      }
    end,
  },

  -- load luasnips + cmp related in insert mode only
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      {
        -- snippet plugin
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require("plugins.configs.others").luasnip(opts)
        end,
      },

      -- autopairing of (){}[] etc
      {
        "windwp/nvim-autopairs",
        opts = {
          fast_wrap = {},
          disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)

          -- setup cmp for autopairs
          local cmp_autopairs = require "nvim-autopairs.completion.cmp"
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },

      -- cmp sources plugins
      {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
      },
    },
    opts = function()
      return require "plugins.configs.cmp"
    end,
    config = function(_, opts)
      require("cmp").setup(opts)
    end,
  },

  {
    "numToStr/Comment.nvim",
    keys = {
      { "gcc", mode = "n",          desc = "Comment toggle current line" },
      { "gc",  mode = { "n", "o" }, desc = "Comment toggle linewise" },
      { "gc",  mode = "x",          desc = "Comment toggle linewise (visual)" },
      { "gbc", mode = "n",          desc = "Comment toggle current block" },
      { "gb",  mode = { "n", "o" }, desc = "Comment toggle blockwise" },
      { "gb",  mode = "x",          desc = "Comment toggle blockwise (visual)" },
    },
    init = function()
      require("core.utils").load_mappings "comment"
    end,
    config = function(_, opts)
      require("Comment").setup(opts)
    end,
  },

  -- file managing , picker etc
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    init = function()
      require("core.utils").load_mappings "nvimtree"
    end,
    opts = function()
      return require "plugins.configs.nvimtree"
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "nvimtree")
      require("nvim-tree").setup(opts)
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = "Telescope",
    init = function()
      require("core.utils").load_mappings "telescope"
    end,
    opts = function()
      return require "plugins.configs.telescope"
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "telescope")
      local telescope = require "telescope"
      telescope.setup(opts)

      -- load extensions
      for _, ext in ipairs(opts.extensions_list) do
        telescope.load_extension(ext)
      end
    end,
  },

  -- Only load whichkey after all the gui
  {
    "folke/which-key.nvim",
    keys = { "<leader>", "<c-r>", "<c-w>", '"', "'", "`", "c", "v", "g" },
    init = function()
      require("core.utils").load_mappings "whichkey"
    end,
    cmd = "WhichKey",
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "whichkey")
      require("which-key").setup(opts)
    end,
  },

  {
    "nvimtools/none-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local null_ls = require("null-ls") -- ✅ this is still 'null-ls'

      local options = {
        sources = {
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.rustfmt,
        },
      }

      null_ls.setup(options)

      vim.api.nvim_set_keymap(
        "n",
        "<leader>nf",
        "<cmd>lua vim.lsp.buf.format({ timeout_ms = 2000 })<CR>",
        { noremap = true, silent = true }
      )
    end,
  },

  {
    "stevearc/conform.nvim",
    init = function(_, opts)
      local conform = require "conform"
      conform.setup(opts)
      vim.keymap.set("n", "<leader>gf", function()
        print(conform.format {
          lsp_fallback = true,
          async = false,
          timeout_ms = 500,
        })
      end)
    end,
  },
}

local config = require("core.utils").load_config()

if #config.plugins > 0 then
  table.insert(default_plugins, { import = config.plugins })
end

require("lazy").setup(default_plugins, config.lazy_nvim)
