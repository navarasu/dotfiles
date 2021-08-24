
"      VIM CORE CONFIG     
"--------------------------
set nocompatible
set number                     " Show current line number
set relativenumber             " Show relative line numbers
set clipboard=unnamed          "Copy yanked to clipboard
set shiftwidth=2
set tabstop=2
set expandtab
set autoread
set background=dark
set smarttab
set incsearch
set ignorecase
set smartcase
set cursorline
set hidden
set nowrap
set shell=bash
"--------------------------
"      KEYBOARD SHORTCUT    
"--------------------------
" remap , to be the leader key
let g:mapleader= "\<space>"
nnoremap <c-p> <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>ff :FloatermNew lf<cr>
map <Leader>r :Rg<CR>
nnoremap <BS> :nohl<CR>
nnoremap <space><space> i<space><esc>
nmap <CR> o<Esc>
"--------------------------
"      PLUGINS    
"--------------------------
call plug#begin('~/.config/nvim/plugged')

" Color schemes
Plug 'navarasu/onedark.nvim'
" Plug 'navarasu/gitcomplete.nvim'
Plug 'hoob3rt/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons' " lua
Plug 'kyazdani42/nvim-tree.lua'
Plug 'tiagovla/tokyodark.nvim'
Plug 'glepnir/dashboard-nvim'
Plug 'folke/which-key.nvim'
Plug 'tweekmonster/startuptime.vim'
" Files Explorer and Search
Plug 'voldikss/vim-floaterm'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'tpope/vim-fugitive'
Plug 'kdheepak/lazygit.nvim'

" Language
Plug 'neovim/nvim-lspconfig'
Plug 'kabouzeid/nvim-lspinstall'
Plug 'hrsh7th/nvim-compe'
Plug 'tzachar/compe-tabnine', { 'do': './install.sh' }
Plug 'tpope/vim-commentary'
Plug 'andymass/vim-matchup'
Plug 'pechorin/any-jump.vim'
Plug 'tpope/vim-surround'
" Syntax
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
call plug#end()

"--------------------------
"      PLUGIN CONFIG    
"--------------------------

" Theme And Colors Config
let g:onedark_style = 'darker'
" let g:onedark_transparent_background = 0
colorscheme onedark
" colorscheme tokyodark
" Floatterm
let g:floaterm_keymap_new    = '<F7>'
let g:floaterm_keymap_prev   = '<F8>'
let g:floaterm_keymap_next   = '<F9>'
let g:floaterm_keymap_toggle = '<F12>'
let g:floaterm_autoclose = 1
let g:floaterm_width = 0.8
let g:floaterm_height = 0.8
let g:floaterm_opener = 'tabe'
let g:matchup_text_obj_linewise_operators = [ 'y' ]
" let g:fzf_preview_window = ['right:50%', 'ctrl-/']
let g:lf_open_new_tab = 1
let g:lf_map_keys =0
let g:toggleterm_terminal_mapping = '<C-t>'

" Syntax
lua <<EOF
-- require('onedark').setup()
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true
  },
}

require('gitsigns').setup {}
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    tabnine = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
  };
}

require 'nvim-treesitter.configs'.setup {
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",

        -- Or you can define your own textobjects like this
        ["iF"] = {
          python = "(function_definition) @function",
          cpp = "(function_definition) @function",
          c = "(function_definition) @function",
          java = "(method_declaration) @function",
        },
      },
    },
  },
}

local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("n", "cf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

end

require'lspinstall'.setup()
--local servers = require'lspinstall'.installed_servers()
--local servers = { "pyright", "solargraph", "java", "tsserver" }

local servers = { "python", "solargraph"}
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
  }
end

require('telescope').setup {
  defaults = {
    sorting_strategy = "ascending",
    layout_strategy = "horizontal",
    layout_config = {
      prompt_position = "top",
      horizontal = {
        mirror = false,
      },
      vertical = {
        mirror = false,
      },
    },
  }
}

require("lualine").setup {
 options = {
    theme = 'onedark',
		}
}

EOF

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect
" Avoid showing message extra message when using completion
set shortmess+=c

let g:nvim_tree_width = 40 "30 by default
let g:nvim_tree_ignore = [ '.git', 'node_modules', '.cache' ] "empty by default
let g:nvim_tree_gitignore = 1 "0 by default
let g:nvim_tree_auto_close = 1 "0 by default, closes the tree when it's the last window
nnoremap <C-n> :NvimTreeToggle<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <leader>n :NvimTreeFindFile<CR>


if (exists("g:loaded_tabline_vim") && g:loaded_tabline_vim) || &cp
  finish
endif
let g:loaded_tabline_vim = 1

function! Tabline()
  let s = ''
  for i in range(tabpagenr('$'))
    let tab = i + 1
    let winnr = tabpagewinnr(tab)
    let buflist = tabpagebuflist(tab)
    let bufnr = buflist[winnr - 1]
    let bufname = bufname(bufnr)
    let bufmodified = getbufvar(bufnr, "&mod")

    let s .= '%' . tab . 'T'
    let s .= (tab == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
    let s .= ' ' . tab .''
    let s .= (bufname != '' ?  ' '. fnamemodify(bufname, ':t') .' '  : '[No Name] ')

    if bufmodified
      let s .= '[+] '
    endif
  endfor

  let s .= '%#TabLineFill#'
  return s
endfunction
set tabline=%!Tabline()
" if has('nvim-0.5')
"   augroup lsp
"     au!
"     au FileType java lua require('jdtls').start_or_attach({cmd = {'/Users/navarasu/.local/share/nvim/lspinstall/java/jdtls.sh'}, init_options= {bundles= {vim.fn.glob('│/Users/navarasu/.local/share/nvim/lspinstall/java/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar')}}, on_attach = attach_java}) 
"   augroup end
" endif

let g:dashboard_custom_header = [
\'                                                   ',
\'                                                   ',
\'                                                   ',
\'                                                   ',
\'                                                   ',
\'    _   __                                         ', 
\'   / | / /___ __   ______ __________ ________  __  ',
\'  /  |/ / __ `/ | / / __ `/ ___/ __ `/ ___/ / / /  ',
\' / /|  / /_/ /| |/ / /_/ / /  / /_/ (__  ) /_/ /   ', 
\'/_/ |_/\__,_/ |___/\__,_/_/   \__,_/____/\__,_/    ',  
\'                                                   ',
\'                                                   ',
\'                                                   ',
\'                                                   ',
\'                                                   ',
\'                                                   ',
\'                                                   ',
\]

