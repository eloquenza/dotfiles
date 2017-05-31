""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""''
" Plugin settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""''

let g:python3_host_prog="/usr/bin/python"
let g:python_host_prog="/usr/bin/python2"
let g:plug_threads = 1

let g:cpp_class_scope_highlight = 1
let g:cpp_experimental_template_highlight = 1

let g:ycm_global_ycm_extra_conf = '~/.config/nvim/plugged/youcompleteme/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'

let g:instant_markdown_slow = 1
let g:instant_markdown_autostart = 0

let g:user_emmet_install_global = 0

let g:ale_statusline_format = ['ᴇ %d', '⚠ %d', '✔']

let g:ale_echo_msg_error_str = 'Err'
let g:ale_echo_msg_warning_str = 'War'
let g:ale_echo_msg_format = '[%severity%] - [%linter%] %s'

let g:airline_powerline_fonts = 1
let g:airline_symbols_ascii = 1

call plug#begin('~/.config/nvim/plugged')

Plug 'junegunn/fzf', { 'dir': '~/.config/fzf', 'do': './install --all' }

" colorschemes
Plug 'altercation/vim-colors-solarized'
Plug 'chriskempson/base16-vim'

" distraction free modes / org modes
Plug 'junegunn/goyo.vim'
Plug 'amix/vim-zenroom2'
Plug 'jceb/vim-orgmode'
Plug 'suan/vim-instant-markdown'

" vim improvements
Plug 'ntpeters/vim-better-whitespace'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'easymotion/vim-easymotion'
Plug 'godlygeek/tabular'
Plug 'christoomey/vim-tmux-navigator'
Plug 'mbbill/undotree'

" code highlighting, linters and co
Plug 'w0rp/ale'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'valloric/youcompleteme', { 'do': './install.py --clang-completer'}
Plug 'shougo/deoplete.nvim'
Plug 'lyuts/vim-rtags'
Plug 'tpope/vim-fugitive'
Plug 'majutsushi/tagbar'

" language addons
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'drmikehenry/vim-headerguard'

" html/css
Plug 'mattn/emmet-vim'

" latex
Plug 'lervag/vimtex'

call plug#end()

call airline#parts#define_function('ALE', 'ALEGetStatusLine')
call airline#parts#define_condition('ALE', 'exists("*ALEGetStatusLine")')
let g:airline_section_error = airline#section#create_right(['ALE'])

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""''
" General settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""''

syntax enable
set background=dark
colorscheme solarized

set encoding=utf8

" set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Turn on the WiLd menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc

"Always show current position
set ruler

" Height of the command bar
set cmdheight=2

" A buffer becomes hidden when it is abandoned
set hidden

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Highlight whitespace with symbols
set list
set showbreak=↪
set listchars=eol:¬,extends:…,precedes:…,tab:→\ ,nbsp:␣,trail:•

" Consider < and > a pair
set matchpairs+=<:>

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

set cursorline
set relativenumber
set number

" change split direction
set splitbelow
set splitright

" for smooth inline and live incremental substitution preview
set inccommand=nosplit

filetype plugin on
filetype indent on

" Set backup/undo dirs
set backupdir=~/.config/nvim/tmp/backups//
set undodir=~/.config/nvim/tmp/undo//

" Make the folders automatically if they don't already exist.
if !isdirectory(expand(&backupdir))
	call mkdir(expand(&backupdir), 'p')
endif

if !isdirectory(expand(&undodir))
	call mkdir(expand(&undodir), 'p')
endif

" Persistent Undo, Vim remembers everything even after the file is closed.
set undofile
set undolevels=500
set undoreload=500

" Use the OS clipboard by default
set clipboard+=unnamedplus

set laststatus=2

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""''
" Keybindings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""''

let mapleader = " "
nnoremap <SPACE> <Nop>

" Copy/paste to system clipboard
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>yy "+yy
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee % > /dev/null

vnoremap <C-c> "*y

" change split nav from c-w+arrow|hjkl to C-hjkl
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Map the capital equivalent for easier save/exit
cabbrev Wq wq
cabbrev W w
cabbrev Q q

nnoremap <F5> :UndotreeToggle<CR>
nmap <F6> :TagbarToggle<CR>

" jump to ale errors
"nmap <silent> <C-k> <Plug>(ale_previous_wrap)
"nmap <silent> <C-j> <Plug>(ale_next_wrap)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""''
" Misc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""''

" Wrap text in markdown and in yaml files
autocmd BufNewFile,BufRead,BufEnter *.md setlocal wrap linebreak
autocmd FileType markdown setlocal wrap linebreak
autocmd BufNewFile,BufRead,BufEnter *.yml setlocal wrap linebreak
autocmd FileType yaml setlocal wrap linebreak
autocmd BufNewFile,BufRead,BufEnter *.txt setlocal wrap linebreak
autocmd FileType text setlocal wrap linebreak

" enable emmet only for html/css
autocmd FileType html,css EmmetInstall

" auto remove whitespace
autocmd BufWritePre * StripWhitespace

" Display comments in italics
highlight Comment cterm=italic

" Italics and bold in markdown files
highlight htmlItalic cterm=italic
highlight htmlBold cterm=bold

" Make yank repeatable with .
set cpoptions+=y

"------------------------------------------------------------
" Abbreviations

inoreabbrev dennis@ dennisgrabowski@gmx.de
inoreabbrev dennis.@ dennis.grabowski@stud.hs-hannover.de
inoreabbrev grabowski@ grabowski@tixeltec.com