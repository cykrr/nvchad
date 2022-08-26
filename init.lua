vim.defer_fn(function()
  pcall(require, "impatient")
end, 0)

require "core"
require "core.options"

-- setup packer + plugins
local fn = vim.fn
local install_path = fn.stdpath "data" .. "/site/pack/packer/opt/packer.nvim"

pcall(require, "custom")

require("core.utils").load_mappings()


vim.g.vim_markdown_fenced_languages = {'html', 'python', 'lua', 'cpp', 'typescript', 'javascript', 'java'}
