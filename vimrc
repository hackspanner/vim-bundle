"
"This stuff requires Vundle
"install with:
"git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
"
set nocompatible   "be iMproved, required by vundle
filetype off       "required by vundle

"set the runtime path the include vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

"let vundle manage itself
Plugin 'VundleVim/Vundle.vim'

"add all vundle plugins here:
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'zah/nim.vim'
Plugin 'elixir-lang/vim-elixir'
Plugin 'lambdatoast/elm.vim'
Plugin 'vim-jp/ctags'
Plugin 'vim-scripts/paredit.vim'
Plugin 'vim-scripts/VimClojure'
Plugin 'tpope/vim-fireplace'
Plugin 'lfex/vim-lfe'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

"All vundle plugins must be added before the following line
call vundle#end()
filetype plugin indent on

"Merlin for OCaml
let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
execute "set rtp+=" . g:opamshare . "/merlin/vim"
" execute "helptags " . g:opamshare . "/merlin/vim/doc"

"Ocsigen filetypes
au BufRead,BufNewFile *.eliom setfiletype ocaml

filetype plugin indent on
syntax on
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set backupdir=/tmp
set directory=/tmp
set number
set nowrap
set laststatus=2 "show airline in a single window

" use return after search to disable highlight
nnoremap <CR> :noh<CR><CR>
" use jk to change mode
imap jk <Esc>

colorscheme koehler

