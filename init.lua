-- Luke Green's NVIM config
-- This heavily leverages three main packages to add support to all languages
-- - nvim-lspconfig and everything that goes with it
-- - nvim-cmp for completion via lsp
-- - nvim-treesitter for syntax highlighting
require('packer').startup(function()
	use 'wbthomason/packer.nvim'
	use 'fatih/vim-go'
	use 'neovim/nvim-lspconfig'
	use 'hrsh7th/nvim-cmp'
	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-cmdline'
	use 'hrsh7th/cmp-path'
	use 'hrsh7th/cmp-vsnip'
	use 'hrsh7th/vim-vsnip'
	use 'tpope/vim-fugitive'
	use 'tpope/vim-commentary'
	use {
		'nvim-telescope/telescope.nvim',
		requires = { {'nvim-lua/plenary.nvim'} }
	}
	use 'editorconfig/editorconfig-vim'
	use 'mhinz/vim-signify'
	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'kyazdani42/nvim-web-devicons', opt = true }
	}
	use 'tpope/vim-sleuth'
	use 'RRethy/nvim-base16'
	use 'tinted-theming/base16-vim'
	use {
		'nvim-treesitter/nvim-treesitter',
		run = function()
			local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
			ts_update()
		end,
	}
	use 'vimwiki/vimwiki'
	use 'sbdchd/neoformat'
	use 'Glench/Vim-Jinja2-Syntax'
end)

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.opt.encoding='utf-8'

vim.opt.number = true
vim.opt.autoindent = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.updatetime = 100
vim.opt.tabstop = 4
vim.opt.hlsearch = false
vim.opt.wrap = false

-- Colorscheme
local cmd = vim.cmd
local g = vim.g

local current_theme_name = os.getenv('BASE16_THEME')
if current_theme_name and g.colors_name ~= 'base16-'..current_theme_name then
  cmd('let base16colorspace=256')
  cmd('colorscheme base16-'..current_theme_name)
end

-- Enable colorcolumn for text docs
vim.cmd("autocmd FileType markdown set colorcolumn=80")
vim.cmd("autocmd FileType asciidoc set colorcolumn=80")

-- Vimwiki path
vim.cmd("let g:vimwiki_list = [{'path': '~/life/', 'path_html': '~/public_html/'}]")

-- Don't treat every md file as a wiki
vim.cmd("let g:vimwiki_global_ext = 0")


-- Statusline
require('lualine').setup({ options = { theme = 'base16' }})

-- Lsp Init
local lsp = require'lspconfig'

-- Completion
local cmp = require'cmp'

local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end
	},
	mapping = {
		['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
		['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
		['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
		['<CR>'] = cmp.mapping.confirm({ select = true }),
		["<Tab>"] = cmp.mapping(function(fallback)
		  if cmp.visible() then
			cmp.select_next_item()
		  elseif vim.fn["vsnip#available"](1) == 1 then
			feedkey("<Plug>(vsnip-expand-or-jump)", "")
		  elseif has_words_before() then
			cmp.complete()
		  else
			fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
		  end
		end, { "i", "s" }),		
		["<Down>"] = cmp.mapping(function(fallback)
		  if cmp.visible() then
			cmp.select_next_item()
		  elseif vim.fn["vsnip#available"](1) == 1 then
			feedkey("<Plug>(vsnip-expand-or-jump)", "")
		  elseif has_words_before() then
			cmp.complete()
		  else
			fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
		  end
		end, { "i", "s" }),		
		["<Up>"] = cmp.mapping(function()
		  if cmp.visible() then
			cmp.select_prev_item()
		  elseif vim.fn["vsnip#jumpable"](-1) == 1 then
			feedkey("<Plug>(vsnip-jump-prev)", "")
		  end
		end, { "i", "s" }),
	},
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'vsnip' }
	}, {
		{ name = 'buffer' }
	})
})

cmp.setup.filetype('gitcommit', {
	sources = cmp.config.sources({
		{ name = 'cmp_git' }
	}, {
		{ name = 'buffer' }
	})
})

cmp.setup.cmdline(':', {
	sources = cmp.config.sources({
		{ name = 'path' }
	}, {
		{ name = 'cmdline' }
	})
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local on_attach = function(client, bufnr)
	local bufopts = { noremap=true, silent=true, buffer=bufnr }
	vim.keymap.set('n', '<leader>i', vim.lsp.buf.hover, bufopts)
	vim.keymap.set('n', '<leader>d', vim.lsp.buf.type_definition, bufopts)
end

local border = {
      {"🭽", "FloatBorder"},
      {"▔", "FloatBorder"},
      {"🭾", "FloatBorder"},
      {"▕", "FloatBorder"},
      {"🭿", "FloatBorder"},
      {"▁", "FloatBorder"},
      {"🭼", "FloatBorder"},
      {"▏", "FloatBorder"},
}

-- LSP settings (for overriding per client)
local handlers =  {
  ["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, {border = border}),
  ["textDocument/signatureHelp"] =  vim.lsp.with(vim.lsp.handlers.signature_help, {border = border }),
}

-- Telescope config
require('telescope').setup({
	defaults = {
		layout_strategy = 'vertical'
	}
})

-- Tree sitter config
-- Right now just used for python
require'nvim-treesitter.configs'.setup {
	ensure_installed = { "python", "go", "lua", "tsx", "typescript" },
	sync_install = false,
	auto_install = true,
	highlight = {
		enable = { "python", "go", "lua", "tsx", "typescript" }
	},
	indent = {
		enable = true
	}
}

-- Auto formatting
vim.api.nvim_create_autocmd({"BufWritePre"}, {
	pattern = {"*.py"},
	desc = "Format code",
	command = "Neoformat"
})

-- Go config
vim.api.nvim_exec([[ let g:go_diagnostics_enabled = 0 ]], false)
vim.api.nvim_exec([[ let g:go_metalinter_enabled = [] ]], false)
vim.api.nvim_exec([[ let g:go_highlight_fields = 1 ]], false)
vim.api.nvim_exec([[ let g:go_highlight_functions = 1 ]], false)
vim.api.nvim_exec([[ let g:go_highlight_function_calls = 1 ]], false)
vim.api.nvim_exec([[ let g:go_highlight_extra_types = 1 ]], false)
vim.api.nvim_exec([[ let g:go_highlight_operators = 1 ]], false)

-- tsserver
lsp.tsserver.setup{
	capabilities = capabilities,
	on_attach = function(client, buffer)
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
		on_attach()
	end,
	handlers = handlers
}
-- Gopls
lsp.gopls.setup{
	on_attach = on_attach,
	capabilities = capabilities,
	handlers = handlers
}
-- Python
lsp.pyright.setup{
	capabilities = capabilities,
	on_attach = on_attach,
	handlers = handlers
}

--- Autoformat
vim.g.neoformat_python_autopep8 = {
	exe = 'black',
}

vim.g.neoformat_enabled_python = {'black'}

-- Rust
lsp.rust_analyzer.setup{
	capabilities = capabilities,
	on_attach = on_attach,
	handlers = handlers
}

-- Ruby
lsp.solargraph.setup{
	capabilities = capabilities,
	on_attach = on_attach,
	handlers = handlers
}

-- Elixir
lsp.elixirls.setup{
	cmd = { vim.fn.expand("~/bin/elixir-ls/language_server.sh") }
}

-- Global Binds
-- Telescope
vim.api.nvim_set_keymap('n', '<leader>ff', ':Telescope git_files<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fs', ':Telescope live_grep<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fb', ':Telescope buffers<cr>', { noremap = true })

-- Go Keybinds
vim.api.nvim_exec([[ autocmd BufEnter *.go nmap <leader>tt <Plug>(go-test) ]], false)
vim.api.nvim_exec([[ autocmd BufEnter *.go nmap <leader>tf <Plug>(go-test-func) ]], false)
vim.api.nvim_exec([[ autocmd BufEnter *.go nmap <leader>tc <Plug>(go-coverage-toggle) ]], false)
vim.api.nvim_exec([[ autocmd BufEnter *.go nmap <leader>gi <Plug>(go-info) ]], false)
vim.api.nvim_exec([[ autocmd BufEnter *.go nmap <leader>gm <Plug>(go-implements) ]], false)
vim.api.nvim_exec([[ autocmd BufEnter *.go nmap <leader>gd <Plug>(go-describe) ]], false)
vim.api.nvim_exec([[ autocmd BufEnter *.go nmap <leader>gc <Plug>(go-callers) ]], false)
