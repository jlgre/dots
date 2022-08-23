-- Luke Green's NVIM config
-- Supported langs
-- - Go
-- - Javascript/Typescript
-- - Python
-- Things I want
-- - Telescope to show recent files
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
	use 'morhetz/gruvbox'
	use 'altercation/vim-colors-solarized'
	use 'euclidianAce/BetterLua.vim'
	use 'tpope/vim-fugitive'
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
	use 'MaxMEllon/vim-jsx-pretty'
	use 'tpope/vim-sleuth'
	use 'leafgarland/typescript-vim'
	use 'pangloss/vim-javascript'
end)

vim.g.mapleader = ' '
vim.opt.encoding='utf-8'

vim.opt.number = true
vim.opt.autoindent = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.updatetime = 100
vim.opt.tabstop = 4
vim.opt.hlsearch = false
vim.opt.wrap = false

-- Colorscheme
vim.opt.background = 'light'
vim.cmd('colorscheme solarized')

-- Statusline
require('lualine').setup()

-- Lsp Init
local lsp = require'lspconfig'

-- Completion
local cmp = require'cmp'

cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end
	},
	mapping = {
		['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
		['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
		['C-Space'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
		['<CR>'] = cmp.mapping.confirm({ select = true })
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

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Telescope config
require('telescope').setup({
	defaults = {
		layout_strategy = 'vertical'
	}
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
		client.resolved_capabilities.document_formatting = false
		client.resolved_capabilities.document_range_formatting = false
		vim.api.nvim_buf_set_keymap(buffer, 'n', '<leader>i', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true })
	end
}
-- Gopls
lsp.gopls.setup{
	capabilities = capabilities
}
-- Pylsp
lsp.pylsp.setup{
	capabilities = capabilities,
	settings = {
		pylsp = {
			plugins = {
				pycodestyle = {
					ignore = {'W391'},
					maxLineLength = 100
				}
			}
		}
	}
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
