return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      vim.defer_fn(function()
        require 'nvim-treesitter.configs'.setup {
          -- A list of parser names, or "all" (the listed parsers MUST always be installed)
          ensure_installed = { "c", "lua", "vim", "rust", "vimdoc", "query", "markdown", "markdown_inline" },

          -- Install parsers synchronously (only applied to `ensure_installed`)
          sync_install = false,

          ignore_install = {},
          modules = {},

          -- Automatically install missing parsers when entering buffer
          -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
          auto_install = false,

          highlight = {
            enable = true,
            -- use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
            ---@diagnostic disable-next-line: unused-local
            disable = function(lang, buf)
              local max_filesize = 100 * 1024 -- 100 KB
              ---@diagnostic disable-next-line: undefined-field
              local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
              if ok and stats and stats.size > max_filesize then
                return true
              end
            end,

            -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
            -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
            -- Using this option may slow down your editor, and you may see some duplicate highlights.
            -- Instead of true it can also be a list of languages
            additional_vim_regex_highlighting = false,

          },
          incremental_selection = {
            enable = true,
            keymaps = {
              init_selection = "<M-space>",
              node_incremental = "<M-space>",
              scope_incremental = false,
              node_decremental = "<bs>",
            },
          },


          textobjects = {
            select = {
              enable = true,

              -- Automatically jump forward to textobj, similar to targets.vim
              lookahead = true,

              keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                -- You can optionally set descriptions to the mappings (used in the desc parameter of
                -- nvim_buf_set_keymap) which plugins like which-key display
                ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                -- You can also use captures from other query groups like `locals.scm`
                ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
              },
              -- You can choose the select mode (default is charwise 'v')
              --
              -- Can also be a function which gets passed a table with the keys
              -- * query_string: eg '@function.inner'
              -- * method: eg 'v' or 'o'
              -- and should return the mode ('v', 'V', or '<c-v>') or a table
              -- mapping query_strings to modes.
              -- selection_modes = {
              --   ['@parameter.outer'] = 'v', -- charwise
              --   ['@function.outer'] = 'V',  -- linewise
              --   ['@class.outer'] = '<c-v>', -- blockwise
              -- },
              -- If you set this to `true` (default is `false`) then any textobject is
              -- extended to include preceding or succeeding whitespace. Succeeding
              -- whitespace has priority in order to act similarly to eg the built-in
              -- `ap`.
              --
              -- Can also be a function which gets passed a table with the keys
              -- * query_string: eg '@function.inner'
              -- * selection_mode: eg 'v'
              -- and should return true or false
              -- include_surrounding_whitespace = true,
            },
          },
        }
      end, 0)
    end
  }
}
