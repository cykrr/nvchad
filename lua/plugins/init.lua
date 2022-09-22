vim.cmd "packadd packer.nvim"

local plugins = {
  ["nvim-treesitter/nvim-treesitter-context"] = {
    after = "nvim-treesitter",
    config = function ()
      require'treesitter-context'.setup {
        enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
        max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
        trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
        -- For all filetypes
        -- Note that setting an entry here replaces all other patterns for this entry.
        -- By setting the 'default' entry below, you can control which nodes you want to
        -- appear in the context window.
        default = {
          'class',
          'function',
          'method',
           -- 'for',
           -- 'while',
           -- 'if',
           -- 'switch',
           -- 'case',
        },
        -- Example for a specific filetype.
        -- If a pattern is missing, *open a PR* so everyone can benefit.
        --   rust = {
          --       'impl_item',
          --   },
        },
        exact_patterns = {
          -- Example for a specific filetype with Lua patterns
          -- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
          -- exactly match "impl_item" only)
          -- rust = true,
        },

        -- [!] The options below are exposed but shouldn't require your attention,
        --     you can safely ignore them.

        zindex = 20, -- The Z-index of the context window
        mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
        separator = nil, -- Separator between context and content. Should be a single character string, like '-'.
      }
    end,
  },

  ["tpope/vim-markdown"] = { 
    ft = {"md", "markdown"},
    config = function ()
      vim.g.markdown_folding = true
    end,
},

-- Used for markdownlint
  ['jose-elias-alvarez/null-ls.nvim'] = {
    ft = {"md", "markdown", "python"},
    config = function()
      require("null-ls").setup({
        sources = {
          require"null-ls".builtins.diagnostics.markdownlint,
          require"null-ls".builtins.formatting.prettier,
--          require"null-ls".builtins.diagnostics.pylint,
          require"null-ls".builtins.formatting.black
        },
        update_in_insert = true,
        debounce = 200,
      })
    end,
  },

-- Runs code on markdown code fences
  ['jubnzv/mdeval.nvim'] = {
    ft = {"md", "markdown"},
    config = function ()
      require'mdeval'.setup {
        require_confirmation = false,
        eval_options = {
          cpp = {
            command = {"g++", "-std=c++20"},
            default_header = [[
            #include <iostream>
            ]]
          },
          python = {
            command = {"python"}
          }
        }
      }
    end
  },

-- Disabled
--  ['aserowy/tmux.nvim'] = {
--    event = "InsertEnter",
--    config = function()
--      require'tmux'.setup {
--        copy_sync = {
--          enable = true
--        },
--        resize = {
--          enable_default_keybindings = true
--        }
--      }
--    end
--  },

-- Live viewer of markdown documents
  ["iamcco/markdown-preview.nvim"] = {
    ft = {"md", "markdown"},
    run = "cd app && yarn install",
  },

  ["mfussenegger/nvim-jdtls"] = {ft = "java"},


-- Package Manager
  ["wbthomason/packer.nvim"] = {
    cmd = require("core.lazy_load").packer_cmds,
    config = function()
      require "plugins"
    end,
  },

-- NvChad stuff
-- nvchad
  ["NvChad/extensions"] = { module = { "telescope", "nvchad" } },

  ["NvChad/base46"] = {
    config = function()
      local ok, base46 = pcall(require, "base46")

      if ok then
        base46.load_theme()
      end
    end,
  },

  ["NvChad/ui"] = {
    after = "base46",
    config = function()
      require("plugins.configs.others").nvchad_ui()
    end,
  },

  ["NvChad/nvterm"] = {
    module = "nvterm",
    config = function()
      require "plugins.configs.nvterm"
    end,
    setup = function()
      require("core.utils").load_mappings "nvterm"
    end,
  },

  ["NvChad/nvim-colorizer.lua"] = {
    opt = true,
    setup = function()
      require("core.lazy_load").on_file_open "nvim-colorizer.lua"
    end,
    config = function()
      require("plugins.configs.others").colorizer()
    end,
  },
-- icons
  ["kyazdani42/nvim-web-devicons"] = {
    after = "ui",
    module = "nvim-web-devicons",
    config = function()
      require("plugins.configs.others").devicons()
    end,
  },

-- Display key helper
  ["folke/which-key.nvim"] = {
    -- Only load whichkey after all the gui

    -- disable = true,
    module = "which-key",
    keys = "<leader>",
    config = function()
      require "plugins.configs.whichkey"
    end,
    setup = function()
      require("core.utils").load_mappings "whichkey"
    end,
  },

-- Shows start and end of code blocks
  ["lukas-reineke/indent-blankline.nvim"] = {
    opt = true,
    setup = function()
      require("core.lazy_load").on_file_open "indent-blankline.nvim"
      require("core.utils").load_mappings "blankline"
    end,
    config = function()
      require("plugins.configs.others").blankline()
    end,
  },

-- Dependency
  ["nvim-treesitter/nvim-treesitter"] = {
    module = "nvim-treesitter",
    setup = function()
      require("core.lazy_load").on_file_open "nvim-treesitter"
    end,
    cmd = require("core.lazy_load").treesitter_cmds,
    run = ":TSUpdate",
    config = function()
      require "plugins.configs.treesitter"
    end,
  },

-- Git Signs
  -- Git Signs
  ["lewis6991/gitsigns.nvim"] = {
    ft = "gitcommit",
    setup = function()
      require("core.lazy_load").gitsigns()
    end,
    config = function()
      require("plugins.configs.others").gitsigns()
    end,
  },

-- Mason & LSPConfig
  -- lsp stuff

  ["williamboman/mason.nvim"] = {
    cmd = require("core.lazy_load").mason_cmds,
    config = function()
      require "plugins.configs.mason"
    end,
  },

  ["neovim/nvim-lspconfig"] = {
    opt = true,
    setup = function()
      require("core.lazy_load").on_file_open "nvim-lspconfig"
    end,
    config = function()
      require "plugins.configs.lspconfig"
    end,
  },

-- LuaSnips & cmp
  -- load luasnips + cmp related in insert mode only

  ["rafamadriz/friendly-snippets"] = {
    module = { "cmp", "cmp_nvim_lsp" },
    event = "InsertEnter",
  },

  ["hrsh7th/nvim-cmp"] = {
    after = "friendly-snippets",
    config = function()
      require "plugins.configs.cmp"
    end,
  },

  ["L3MON4D3/LuaSnip"] = {
    wants = "friendly-snippets",
    after = "nvim-cmp",
    config = function()
      require("plugins.configs.others").luasnip()
    end,
  },

  ["saadparwaiz1/cmp_luasnip"] = {
    after = "LuaSnip",
  },

  ["hrsh7th/cmp-nvim-lua"] = {
    after = "cmp_luasnip",
  },

  ["hrsh7th/cmp-nvim-lsp"] = {
    after = "cmp-nvim-lua",
  },

  ["hrsh7th/cmp-buffer"] = {
    after = "cmp-nvim-lsp",
  },

  ["hrsh7th/cmp-path"] = {
    after = "cmp-buffer",

  },

  -- misc plugins
  ["windwp/nvim-autopairs"] = {
    after = "nvim-cmp",
    config = function()
      require("plugins.configs.others").autopairs()
      local Rule = require("nvim-autopairs.rule")
      local ap = require("nvim-autopairs")
      ap.add_rule(Rule("$", "$", "markdown"))
      ap.add_rule(Rule("*", "*", "markdown"))


    end,
  },

  ["goolord/alpha-nvim"] = {
    after = "base46",
    disable = true,
    config = function()
      require "plugins.configs.alpha"
    end,
  },

  ["numToStr/Comment.nvim"] = {
    module = "Comment",
    keys = { "gc", "gb" },
    config = function()
      require("plugins.configs.others").comment()
    end,
    setup = function()
      require("core.utils").load_mappings "comment"
    end,
  },

  -- file managing , picker etc
  ["kyazdani42/nvim-tree.lua"] = {
    ft = "alpha",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    config = function()
      require "plugins.configs.nvimtree"
    end,
    setup = function()
      require("core.utils").load_mappings "nvimtree"
    end,
  },

  ["nvim-telescope/telescope.nvim"] = {
    cmd = "Telescope",
    config = function()
      require "plugins.configs.telescope"
    end,
    setup = function()
      require("core.utils").load_mappings "telescope"
    end,
  },

  ["nvim-lua/plenary.nvim"] = { module = "plenary" },

  -- Speed up deffered plugins
  ["lewis6991/impatient.nvim"] = {},
}

require("core.packer").run(plugins)
