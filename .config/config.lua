-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
--
lvim.plugins = {
  { "towolf/vim-helm" },
  { "towolf/vim-helm" },
  { "NLKNguyen/papercolor-theme" },
  { "oxfist/night-owl.nvim" },
  { "Mofiqul/dracula.nvim" },
}

lvim.colorscheme = "night-owl"

-- Keybinding for previous buffer
lvim.keys.normal_mode["b"] = ":bp<CR>"

-- Keybinding for next buffer
-- lvim.keys.normal_mode["n"] = ":bn<CR>"
lvim.keys.normal_mode["z"] = ":bz<CR>"

-- Keybinding for horizontal split
lvim.keys.normal_mode["<C-w>s"] = ":vsplit<CR>"


local lspconfig = require('lspconfig')

-- Function to check if the directory contains specific Helm-related files
local function is_helm_directory()
  local dir_path = vim.fn.expand('%:p:h')
  local chart_yaml_path = vim.fn.findfile('Chart.yaml', dir_path .. ';')
  local chart_yml_path = vim.fn.findfile('Chart.yml', dir_path .. ';')
  local helpers_tpl_path = vim.fn.findfile('_helpers.tpl', dir_path .. ';')
  local tpl_files = vim.fn.globpath(dir_path, '*.tpl')

  return chart_yaml_path ~= "" or chart_yml_path ~= "" or helpers_tpl_path ~= "" or tpl_files ~= ""
end

-- Function to disable yamlls for Helm files
function disable_yamlls_for_helm()
  local bufnr = vim.api.nvim_get_current_buf()
  if not vim.api.nvim_buf_is_valid(bufnr) then return end -- Check for buffer validity
  if is_helm_directory() or vim.bo[bufnr].filetype == "helm" then
    -- Disable diagnostics for this buffer
    vim.diagnostic.disable(bufnr)
    vim.defer_fn(function()
      if not vim.api.nvim_buf_is_valid(bufnr) then return end -- Additional check here
      vim.diagnostic.reset(nil, bufnr)
    end, 1000)
  end
end

-- Set up yamlls
lspconfig.yamlls.setup{
  on_attach = function(client, bufnr)
    -- Check if the buffer should disable yamlls when attached
    disable_yamlls_for_helm()
    -- Additional on_attach logic (keybindings, etc.) can go here
  end
}

-- Autocommand to run the disable function on every buffer enter
vim.cmd [[
  augroup DisableYamllsForHelm
    autocmd!
    autocmd BufEnter * lua disable_yamlls_for_helm()
  augroup END
]]

vim.opt.termguicolors = true
vim.cmd [[highlight IndentBlanklineIndent1 guibg=#1f1f1f gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent2 guibg=#1a1a1a gui=nocombine]]

require("indent_blankline").setup {
    char = "",
    char_highlight_list = {
        "IndentBlanklineIndent1",
        "IndentBlanklineIndent2",
    },
    space_char_highlight_list = {
        "IndentBlanklineIndent1",
        "IndentBlanklineIndent2",
    },
    show_trailing_blankline_indent = false,
}

