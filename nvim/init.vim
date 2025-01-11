" change leader
let g:mapleader = "\<Space>"
set wildmenu
" set termguicolors (needs to be before nvim-colorizer)
set termguicolors

" Plugins
call plug#begin()
Plug 'nvim-lua/plenary.nvim' " library required by neo-tree, renamer, etc

" lsp stuff
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig' " LSP config


Plug 'nvim-treesitter/nvim-treesitter'
Plug 'kyazdani42/nvim-web-devicons'
" Plug 'sheerun/vim-polyglot'
Plug 'loctvl842/monokai-pro.nvim'
Plug 'numToStr/Comment.nvim'
Plug 'kylechui/nvim-surround'
Plug 'nvim-lualine/lualine.nvim' 
Plug 'LunarWatcher/auto-pairs'
Plug 'vitalk/vim-shebang' 
Plug 'MunifTanjim/nui.nvim' 
Plug 'akinsho/bufferline.nvim', { 'tag': 'v3.*' }
Plug 'tiagovla/scope.nvim'
Plug 'RRethy/vim-illuminate' 
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'nvim-neo-tree/neo-tree.nvim'
Plug 'filipdutescu/renamer.nvim'
Plug 'folke/which-key.nvim'
Plug 'MaximilianLloyd/ascii.nvim'
" Plug 'goolord/alpha-nvim'
Plug 'glepnir/dashboard-nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'akinsho/toggleterm.nvim'
Plug 'SmiteshP/nvim-navic'
Plug 'utilyre/barbecue.nvim' 
" Plug 'gelguy/wilder.nvim' 
Plug 'roxma/nvim-yarp', { 'do': 'pip install -r requirements.txt' }
Plug 'roxma/vim-hug-neovim-rpc' 
Plug 'NvChad/nvim-colorizer.lua'
Plug 'terryma/vim-multiple-cursors'

Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-path'
Plug 'onsails/lspkind.nvim' " customization (icons)
Plug 'hrsh7th/nvim-cmp'

call plug#end()

set mousemoveevent

lua << END
require("mason").setup {}
require("mason-lspconfig").setup {}

local navic = require("nvim-navic")
local cmp = require("cmp")
local lspkind = require("lspkind")
cmp.setup {
	formatting = {
		-- format = lspkind.cmp_format({
		-- 	mode = "symbol"
		-- })
		fields = { "kind", "abbr", "menu" },
		format = function(entry, vim_item)
			local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
			local strings = vim.split(kind.kind, "%s", { trimempty = true })
			kind.kind = " " .. (strings[1] or "") .. " "
			kind.menu = "    (" .. (strings[2] or "") .. ")"

			return kind
		end,
	},
	window = {
		completion = {
			winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
			col_offset = -3,
			side_padding = 0,
		},
	},
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "buffer" }
	}),
}

cmp.setup.cmdline({ '/', '?' }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' }
	}
})
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'path' }
	}, {
		{ name = 'cmdline' }
	})
})


local capabilities = require("cmp_nvim_lsp").default_capabilities()
-- Auto LSP setup using mason-lspconfig
require("mason-lspconfig").setup_handlers {
	function (server_name)
		require("lspconfig")[server_name].setup {
			capabilities = capabilities,
			-- bad solution, but this makes all LSPs not use a root directory (bc eslint and etc dont work without)
			root_dir = function(fname)
				return vim.loop.cwd()
			end,
			on_attach = function(client, bufnr)
				-- if client.server_capabilities.documentSymbolProvider then
					navic.attach(client, bufnr)
				-- end
			end,
		}
	end,
}

require("Comment").setup {}
require("lualine").setup {
	options = {
		theme = "monokai-pro"
	}
}
require("monokai-pro").setup({ filter = "spectrum" })
require("bufferline").setup {
	options = {
		separator_style = "slant",
		diagnostics = "nvim_lsp",
		hover = {
			enabled = true,
			delay = 0,
			reveal = {"close"}
		}
	}
}
require("scope").setup {}
require("indent_blankline").setup {
    space_char_blankline = " ",
    show_current_context = true,
    show_current_context_start = true,
}
require("nvim-treesitter.configs").setup {
	highlight = {
		enable = true,
	},
	indent = {
		enable = true
	}
}
require("which-key").setup {}
require("renamer").setup {}
-- local alpha_theme = require("alpha.themes.dashboard")
-- alpha_theme.section.header.val = require("ascii").art.text.neovim.sharp
-- require("alpha").setup(alpha_theme.opts)
require("dashboard").setup {
	theme = "doom",
    config = {
        center = {

        }
    }
}
require("illuminate").configure {}
require("toggleterm").setup {}
require("nvim-navic").setup {}
require("barbecue").setup {
	-- theme = "monokai-pro"
}
require("telescope").setup {
    pickers = {
        colorscheme = {
            enable_preview = true
        }
    }
}
-- local wilder = require("wilder")
-- wilder.setup({modes = {':', '/', '?'}})
-- -- wilder.set_option('renderer', wilder.popupmenu_renderer(
-- -- 	wilder.popupmenu_palette_theme({
-- -- 		border = 'rounded',
-- -- 		max_height = '75%',      -- max height of the palette
-- -- 		min_height = 0,          -- set to the same as 'max_height' for a fixed height window
-- -- 		prompt_position = 'top', -- 'top' or 'bottom' to set the location of the prompt
-- -- 		reverse = 0,             -- set to 1 to reverse the order of the list, use in combination with 'prompt_position'
-- -- 	})
-- -- ))
-- wilder.set_option('renderer', wilder.popupmenu_renderer({
-- 	highlighter = wilder.basic_highlighter(),
-- 	left = {' ', wilder.popupmenu_devicons()},
-- 	right = {' ', wilder.popupmenu_scrollbar()},
-- }))
-- wilder.set_option('pipeline', {
-- 	wilder.branch(
-- 		wilder.python_file_finder_pipeline({
-- 			file_command = {'rg', '--files'}, 
-- 			dir_command = {'fd', '-td'},
-- 			filters = {'fuzzy_filter', 'difflib_sorter'},
-- 		}),
-- 		wilder.cmdline_pipeline(),
-- 		wilder.python_search_pipeline()
-- 	),
-- })
-- require("colorizer").setup {
--     "*",
--     a = {
--         RRGGBBAA = true,
--     },
-- 	css = {
--         css_fn = true,
--     }
-- }
require("colorizer").setup {
    filetypes = {
        "*",
        css = {
            css = true,
        },
    },
    user_default_options = {
        RRGGBBAA = true,
    },
}
vim.g.neo_tree_remove_legacy_commands = 1
function _G.set_terminal_keymaps()
  local opts = {buffer = 0}
  -- vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  -- vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  -- vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  -- vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  -- vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  -- vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  -- vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
    -- vim.keymap.set('t', '<C-e>', [[<Cmd>ToggleTerm<CR>]], opts)
end
-- vim.keymap.set('t', '<C-e>', [[<Cmd>ToggleTerm<CR>]], opts)
-- vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
END

"" Theme
colorscheme monokai-pro

"" Shebang Filetypes
AddShebangPattern! python ^#!.*[s]\?bin/env\ python3\>


""Editing
set tabstop=4 				" set tab size to 4 spaces
set softtabstop=4 			" see multiple spaces as tabstops
set shiftwidth=4			" width for autoindents (?)
set autoindent    			" automatically indent the amount already typed
set expandtab
set smarttab
set cindent 
set smartindent
set indentexpr=nvim_treesitter#indent()

set wildmode=longest,list	" bash-like tab completion
set clipboard=unnamedplus   " use system clipboard
set mouse=a					" enable mouse
filetype plugin indent on   " enable auto-indenting depending on file type
set whichwrap=b,s,<,>,[,],h,l
set nomodeline				" Disable 'modeline' (file headings can do stuff)
autocmd BufNewFile,BufRead * setlocal formatoptions-=cro " don't continue comments on the next line

" Display
set number					" line numbers
" set relativenumber			" relative line numbers
syntax on					" enable syntax highlighting
"set cc=80					" 80 column border
set cursorline           	" highlight cursor's current line

" Custom commands
command! -nargs=1 -complete=help H :enew | :set buftype=help | :h <args>

" Keybinds
noremap <silent> <F2> <cmd>lua require('renamer').rename({empty=true})<cr>
noremap <silent> <leader>r <cmd>lua require('renamer').rename({empty=true})<cr>
noremap <C-h> <Cmd>wincmd h<CR>
noremap <C-j> <Cmd>wincmd j<CR>
noremap <C-k> <Cmd>wincmd k<CR>
noremap <C-l> <Cmd>wincmd l<CR>
noremap <Space> <NOP>
" leader keybinds
noremap <leader>c <cmd>Telescope colorscheme<cr>
noremap <leader>e <cmd>Neotree toggle<cr>
noremap <leader>f <cmd>Telescope find_files<cr>
noremap <leader>t <cmd>ToggleTerm<cr>
noremap <C-Space> <cmd>ToggleTerm<cr>
" terminal keybinds
tnoremap <C-Space> <cmd>ToggleTerm<cr>
tnoremap <C-h> <Cmd>wincmd h<CR>
tnoremap <C-j> <Cmd>wincmd j<CR>
tnoremap <C-k> <Cmd>wincmd k<CR>
tnoremap <C-l> <Cmd>wincmd l<CR>

" backspace deletes line, shift+backspace deletes content without line
nnoremap <BS> "_dd
nnoremap <S-BS> "_cc<ESC>
vnoremap <BS> "_d

" Colors
hi SpecialKey ctermfg=4 guifg=#fce566
hi Directory ctermfg=4 guifg=#fce566
" renamer.nvim
hi RenamerBorder guifg=#69676c
" vim-illuminate
hi def IlluminatedWordText gui=underline
" cmp
hi CmpItemMenu gui=italic guifg=#69676c
for hl in getcompletion("CmpItemKind", "highlight")
	execute 'hi '.hl.' guibg=#414143'
endfor

" CMP colors, modified from https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#how-to-get-types-on-the-left-and-offset-the-menu
" lua << END
" local colors = {
"   PmenuSel = { bg = "#282C34", fg = "NONE" },
"   Pmenu = { fg = "#C5CDD9", bg = "#22252A" },
"
"   CmpItemAbbrDeprecated = { fg = "#7E8294", bg = "NONE", fmt = "strikethrough" },
"   CmpItemAbbrMatch = { fg = "#82AAFF", bg = "NONE", fmt = "bold" },
"   CmpItemAbbrMatchFuzzy = { fg = "#82AAFF", bg = "NONE", fmt = "bold" },
"   CmpItemMenu = { fg = "#C792EA", bg = "NONE", fmt = "italic" },
"
"   CmpItemKindField = { fg = "#EED8DA", bg = "#B5585F" },
"   CmpItemKindProperty = { fg = "#EED8DA", bg = "#B5585F" },
"   CmpItemKindEvent = { fg = "#EED8DA", bg = "#B5585F" },
"
"   CmpItemKindText = { fg = "#C3E88D", bg = "#9FBD73" },
"   CmpItemKindEnum = { fg = "#C3E88D", bg = "#9FBD73" },
"   CmpItemKindKeyword = { fg = "#C3E88D", bg = "#9FBD73" },
"
"   CmpItemKindConstant = { fg = "#FFE082", bg = "#D4BB6C" },
"   CmpItemKindConstructor = { fg = "#FFE082", bg = "#D4BB6C" },
"   CmpItemKindReference = { fg = "#FFE082", bg = "#D4BB6C" },
"
"   CmpItemKindFunction = { fg = "#EADFF0", bg = "#A377BF" },
"   CmpItemKindStruct = { fg = "#EADFF0", bg = "#A377BF" },
"   CmpItemKindClass = { fg = "#EADFF0", bg = "#A377BF" },
"   CmpItemKindModule = { fg = "#EADFF0", bg = "#A377BF" },
"   CmpItemKindOperator = { fg = "#EADFF0", bg = "#A377BF" },
"
"   CmpItemKindVariable = { fg = "#C5CDD9", bg = "#7E8294" },
"   CmpItemKindFile = { fg = "#C5CDD9", bg = "#7E8294" },
"
"   CmpItemKindUnit = { fg = "#F5EBD9", bg = "#D4A959" },
"   CmpItemKindSnippet = { fg = "#F5EBD9", bg = "#D4A959" },
"   CmpItemKindFolder = { fg = "#F5EBD9", bg = "#D4A959" },
"
"   CmpItemKindMethod = { fg = "#DDE5F5", bg = "#6C8ED4" },
"   CmpItemKindValue = { fg = "#DDE5F5", bg = "#6C8ED4" },
"   CmpItemKindEnumMember = { fg = "#DDE5F5", bg = "#6C8ED4" },
"
"   CmpItemKindInterface = { fg = "#D8EEEB", bg = "#58B5A8" },
"   CmpItemKindColor = { fg = "#D8EEEB", bg = "#58B5A8" },
"   CmpItemKindTypeParameter = { fg = "#D8EEEB", bg = "#58B5A8" },
" }
"
" -- this just applies the colors in the dict
" for k, v in pairs(colors) do
"   local hl_group = k
"   local hl_spec = v
"   if hl_spec.fmt then
"     hl_spec[hl_spec.fmt] = true
"     hl_spec.fmt = nil
"   end
"   vim.api.nvim_set_hl(0, hl_group, hl_spec)
" end
" END


" neovide
if exists("g:neovide")
	set guifont=Maple\ Mono\ NF:h11
endif


