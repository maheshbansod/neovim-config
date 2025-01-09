return {
  {
    dir = "~/projects/ai.nvim",
    config = function()
      require('ai').setup({
        api_key_getter = function()
          -- get it from a file
          local path = vim.fn.stdpath('data') .. "/secrets/google_ai_api_key"
          local lines = vim.fn.readfile(path)
          return lines[1]
        end
      })
      vim.keymap.set({ 'n', 'v' }, '<M-k>', require 'ai'.get_ai_suggestion)
    end
  },
  {
    dir = "~/projects/present.nvim",
  }
}
