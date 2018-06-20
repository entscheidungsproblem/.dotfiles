" set nocompatible

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.local/share/nvim/plugged')

" Wal
Plug 'dylanaraps/wal'

" Python
Plug 'nvie/vim-flake8'

" Latex
Plug 'lervag/vimtex'

" Haskell
Plug 'eagletmt/ghcmod-vim'
Plug 'eagletmt/neco-ghc'

" Autosave
Plug '907th/vim-auto-save'

" Auto-Completion
Plug 'valloric/youcompleteme'

" Linting
Plug 'neomake/neomake'

" Tree Tabs
Plug 'scrooloose/nerdtree'

" Autoformat
"Plug 'Chiel92/vim-autoformat'

" Airline
" Plug 'vim-airline/vim-airline'

" Initialize plugin system
call plug#end()

" Line number
set relativenumber
set number

" Powerline font
" set guifont=PowerlineSymbols\ 10
" let g:airline_powerline_fonts = 1

function! MyOnBattery()
  return readfile('/sys/class/power_supply/ADP1/online') == ['0']
endfunction

colorscheme wal

" Open tree tab on directories
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif

" Run flake8 everytime a python file is written
autocmd BufWritePost *.py call Flake8()

" Autosave
let g:auto_save_events = ["InsertLeave", "TextChanged", "TextChangedI"]


" Auto-Completion
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
let g:ycm_python_binary_path = '/usr/bin/python3'


" Linting
let g:neomake_open_list = 2
let g:neomake_python_enabled_makers = ['flake8']
let g:neomake_cpp_enabled_makers = ['cppcheck', 'cpplint']
let g:neomake_c_enabled_makers = ['cppcheck', 'gcc']
let g:neomake_haskell_enabled_makers = ['hlint']
let g:neomake_tex_enabled_makers = ['proselint', 'lacheck']
let g:neomake_text_enabled_makers = ['proselint', 'writegood']
let g:neomake_zsh_enabled_makers = ['shellcheck', 'zsh']
let g:neomake_go_enabled_makers = ['go', 'golint']
let g:neomake_perl_enabled_makers = ['perlcritic']
let g:neomake_rust_enabled_makers = ['rustc']
let g:neomake_sql_enabled_makers = ['sqlint']
let g:neomake_sh_enabled_makers = ['shellcheck', 'sh']


" Haskell
let g:ycm_semantic_triggers = {'haskell' : ['.']}


if MyOnBattery()
  " Haskell autocomplete details
  let g:necoghc_enable_detailed_browse = 1
  call neomake#configure#automake('w')
else
  call neomake#configure#automake('nw', 1000)
endif
