"This stuff requires Vundle
"install with:
"git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
"
set nocompatible   "be iMproved, required by vundle
filetype off       "required by vundle

"set the runtime path the include vundle and initialize
if has("win32")
  set rtp+=~/vimfiles/bundle/Vundle.vim
else
  set rtp+=~/.vim/bundle/Vundle.vim
endif

call vundle#begin()

"let vundle manage itself
Plugin 'VundleVim/Vundle.vim'

"add all vundle plugins here:
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'tpope/vim-dispatch'
Plugin 'tpope/vim-fugitive'
Plugin 'OmniSharp/omnisharp-vim'
Plugin 'vim-scripts/UltiSnips'
Plugin 'vim-jp/ctags'
Plugin 'vim-scripts/taglist.vim'
Plugin 'zah/nim.vim'
Plugin 'elixir-lang/vim-elixir'
Plugin 'lambdatoast/elm.vim'
Plugin 'vim-scripts/paredit.vim'
Plugin 'vim-scripts/VimClojure'
Plugin 'derekwyatt/vim-scala'
"Plugin 'vim-scripts/ShaderHighLight'
Plugin 'mingchaoyan/vim-shaderlab'
Plugin 'tpope/vim-fireplace'
Plugin 'lfex/vim-lfe'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

"All vundle plugins must be added before the following line
call vundle#end()

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
set number
set nowrap
set laststatus=2 "show airline in a single window
set smartcase

" setup backup/autosave dirs
if has("win32")
  set backupdir=~/_vimtmp
  set directory=~/_vimtmp
else
  set backupdir=/tmp
  set directory=/tmp
endif

" use return after search to disable highlight
nnoremap <CR> :noh<CR><CR>
" use jk to change mode
imap jk <Esc>

"
" OMNISHARP settings
"
"Set server type
"let g:OmniSharp_server_type = 'v1'
let g:OmniSharp_server_type = 'roslyn'
"don't autoselect first item in omnicomplete, show if only one item (for preview)
"remove preview if you don't want to see any documentation whatsoever.
set completeopt=longest,menuone,preview
"Move the preview window (code documentation) to the bottom of the screen, so it doesn't move the code!
"You might also want to look at the echodoc plugin
set splitbelow
" Get Code Issues and syntax errors
" let g:syntastic_cs_checkers = ['syntax', 'semantic', 'issues']
" If you are using the omnisharp-roslyn backend, use the following
let g:syntastic_cs_checkers = ['code_checker']

augroup omnisharp_commands
    autocmd!

    "Set autocomplete function to OmniSharp (if not using YouCompleteMe completion plugin)
    autocmd FileType cs setlocal omnifunc=OmniSharp#Complete

    " Synchronous build (blocks Vim)
    "autocmd FileType cs nnoremap <F5> :wa!<cr>:OmniSharpBuild<cr>
    " Builds can also run asynchronously with vim-dispatch installed
    autocmd FileType cs nnoremap <leader>b :wa!<cr>:OmniSharpBuildAsync<cr>
    " automatic syntax check on events (TextChanged requires Vim 7.4)
    autocmd BufEnter,TextChanged,InsertLeave *.cs SyntasticCheck

    " Automatically add new cs files to the nearest project on save
    autocmd BufWritePost *.cs call OmniSharp#AddToProject()

    "show type information automatically when the cursor stops moving
    autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()

    "The following commands are contextual, based on the current cursor position.

    autocmd FileType cs nnoremap gd :OmniSharpGotoDefinition<cr>
    autocmd FileType cs nnoremap <leader>fi :OmniSharpFindImplementations<cr>
    autocmd FileType cs nnoremap <leader>ft :OmniSharpFindType<cr>
    autocmd FileType cs nnoremap <leader>fs :OmniSharpFindSymbol<cr>
    autocmd FileType cs nnoremap <leader>fu :OmniSharpFindUsages<cr>
    "finds members in the current buffer
    autocmd FileType cs nnoremap <leader>fm :OmniSharpFindMembers<cr>
    " cursor can be anywhere on the line containing an issue
    autocmd FileType cs nnoremap <leader>x  :OmniSharpFixIssue<cr>
    autocmd FileType cs nnoremap <leader>fx :OmniSharpFixUsings<cr>
    autocmd FileType cs nnoremap <leader>tt :OmniSharpTypeLookup<cr>
    autocmd FileType cs nnoremap <leader>dc :OmniSharpDocumentation<cr>
    "navigate up by method/property/field
    autocmd FileType cs nnoremap <C-K> :OmniSharpNavigateUp<cr>
    "navigate down by method/property/field
    autocmd FileType cs nnoremap <C-J> :OmniSharpNavigateDown<cr>

augroup END

" Contextual code actions (requires CtrlP or unite.vim)
nnoremap <leader><space> :OmniSharpGetCodeActions<cr>

" Run code actions with text selected in visual mode to extract method
vnoremap <leader><space> :call OmniSharp#GetCodeActions('visual')<cr>

" rename with dialog
nnoremap <leader>nm :OmniSharpRename<cr>
nnoremap <F2> :OmniSharpRename<cr>

" rename without dialog - with cursor on the symbol to rename... ':Rename newname'
command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")

" Force OmniSharp to reload the solution. Useful when switching branches etc.
nnoremap <leader>rl :OmniSharpReloadSolution<cr>
nnoremap <leader>cf :OmniSharpCodeFormat<cr>

" Load the current .cs file to the nearest project
nnoremap <leader>tp :OmniSharpAddToProject<cr>

" Add syntax highlighting for types and interfaces
nnoremap <leader>th :OmniSharpHighlightTypes<cr>
"Don't ask to save when changing buffers (i.e. when jumping to a type definition)
set hidden

" Enable snippet completion, requires completeopt-=preview
let g:OmniSharp_want_snippet=1

" enable roslyn server, manual start/stop
let g:OmniSharp_server_type = 'roslyn'
let g:OmniSharp_start_server = 0
let g:OmniSharp_stop_server = 0

"
" OMNISHARP end
"

" MY CUSTOM KEYS
" F5 = delete all trailing whitespace
:nnoremap <silent> <F5> :let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>

" Per filetype tabstops
autocmd Filetype cs setlocal ts=4 sw=4 sts=4 expandtab

colorscheme koehler
set guifont=Source_Code_Pro:h13:cANSI:qDRAFT

