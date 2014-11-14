call pathogen#infect()

set encoding=utf-8
set background=dark
"colorscheme oceandeep
"colorscheme murphy
"colorscheme railscasts
"colorscheme dim
"colorscheme vividchalk
colorscheme solarized
set nocompatible
syntax on

" VUNDLE SPESIFIC "
filetype off 
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'tpope/vim-fugitive'

"Javascript plugins: http://oli.me.uk/2013/06/29/equipping-vim-for-javascript/

Plugin 'mustache/vim-mustache-handlebars'
"Mustache/Handlebar
let g:mustache_abbreviations = 1

Plugin 'jelera/vim-javascript-syntax'
Plugin 'pangloss/vim-javascript'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'Raimondi/delimitMate'
Plugin 'scrooloose/syntastic' "NOTE! LINTER FOR JS must be installed with npm install -g jshint
"Syntastic
" This does what it says on the tin. It will check your file on open too, not just on save.
" You might not want this, so just leave it out if you don't.
let g:syntastic_check_on_open=1
let g:syntastic_javascript_checkers = ['jsxhint']

Plugin 'Valloric/YouCompleteMe' "NOTE! You need to install cd ~/.vim/bundle/YouCompleteMe && ./install.sh --clang-completer --omnisharp-completer
"NOTE2: If MacVim crashes to Python error, install it using brew with
"a spesific version
"cd /usr/local/Library/Formula
"git checkout db04c3a /usr/local/Library/Formula/macvim.rb
"brew uninstall macvim
"brew install macvim

"You CompleteMe
" These are the tweaks I apply to YCM's config, you don't need them but they might help.
" YCM gives you popups and splits by default that some people might not like, so these should tidy it up a bit for you.
let g:ycm_add_preview_to_completeopt=0
let g:ycm_confirm_extra_conf=0
set completeopt-=preview

Plugin 'marijnh/tern_for_vim' "~/.vim/bundle/tern_for_vim && npm install

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" VUNDLE END "




" Highlight search terms...
set hlsearch
set incsearch 
"clear search term with esc
nnoremap <esc> :noh<return><esc>

"allow deleting selection without updating the clipboard (yank buffer)
vnoremap x "_x
vnoremap X "_X

"" For vundle to work
"filetype off

"" Setup vundle
"set rtp+=~/.vim/bundle/vundle/
"call vundle#rc()

"" Vim installed bundles
"Bundle 'Valloric/YouCompleteMe'

let mapleader = ","
set ignorecase 
set smartcase

set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tm

map! <C-space> <esc> 

set backspace=2 " make backspace work normal (non-vi style - deletes also previously inserted characters)
set whichwrap+=<,>,h,l  " backspace and cursor keys wrap to next/prev lines

"Spaces instead of tabs. Both Erlang / Python style guide.
set tabstop=8
set shiftwidth=4
set softtabstop=4
set expandtab

map <leader>j :RopeGotoDefinition<CR>
map <leader>r :RopeRename<CR>

"Hilight overlong lines
highlight OverLength ctermbg=red ctermfg=white guibg=#24010F
match OverLength /\%81v.\+/

set number
set scrolloff=3
set autoindent
set showmode
set showcmd
set hidden
set wildmenu
set wildmode=list:longest
set visualbell
set cursorline
set ttyfast
set ruler
set backspace=indent,eol,start
set laststatus=2
set relativenumber
set undofile

set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch
nnoremap <leader><space> :noh<cr>
nnoremap <tab> %
vnoremap <tab> %

set wrap
set textwidth=79
set formatoptions=qrn1
"set colorcolumn=85

"set list
"set listchars=tab:▸\ ,eol:¬

"nnoremap <up> <nop>
"nnoremap <down> <nop>
"nnoremap <left> <nop>
"nnoremap <right> <nop>
"inoremap <up> <nop>
"inoremap <down> <nop>
"inoremap <left> <nop>
"inoremap <right> <nop>
"nnoremap j gj
"nnoremap k gk
nnoremap <down> gj
nnoremap  <up> gk

nnoremap <leader>w <C-w>v<C-w>l

" Gundo plugin for git history browsing
map <leader>h :GundoToggle<CR>

"Disable beeping
set noerrorbells
if has('autocmd')
	autocmd GUIEnter * set vb t_vb=
endif

"---------------------- START ----------------------------
" How to yank and paste to visually selected area overwriting
" text so that the replaced text doesn't go to buffer. So
" that you can do <yank><visually select><paste><visually select>
" <paste> and paste pastes the original yank everytime.

"http://stackoverflow.com/questions/290465/vim-how-to-paste-over-without-overwriting-register/290723#290723
function! RestoreRegister()
	let @" = s:restore_reg
	return ''
endfunction

function! s:Repl()
	let s:restore_reg = @"
	return "p@=RestoreRegister()\<cr>"
endfunction

" NB: this supports "rp that replaces the selection by the
" contents of @r
vnoremap <silent> <expr> p <sid>Repl()

"----------END----------------------

"FuzzyFinder mappings
"map :tf :FuzzyFinderTag<CR>
"map ,t :FuzzyFinderTextMate<CR>

" OPEN RPROJECT WITH F9
:nnoremap <silent> <F9> :Rproject<CR>

" TO MOVE BETWEEN SPLIT WINDOWS
map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_ 

"http://www.vim.org/tips/tip.php?tip_id=1066
"Adds and removes empty lines from up and below cursor
noremap <silent><C-j> :set paste<CR>mzo<Esc>`z:set nopaste<CR>
noremap <silent><C-k> :set paste<CR>mzO<Esc>`z:set nopaste<CR> 

noremap <silent><A-k> mz:silent +g/\m^\s*$/d<CR>`z:noh<CR>
noremap <silent><A-j> mz:silent -g/\m^\s*$/d<CR>`z:noh<CR>

"Moving between buffers
map ,s :bN<CR> 
map ,d :buffers<CR> 
map ,f :bn<CR>

" Previous buffer
map ,g :e#<CR> 

map ,1 :1b<CR> 
map ,2 :2b<CR> 
map ,3 :3b<CR> 
map ,4 :4b<CR> 
map ,5 :5b<CR> 
map ,6 :6b<CR> 
map ,7 :7b<CR> 
map ,8 :8b<CR> 
map ,9 :9b<CR> 
map ,0 :10b<CR>

"Minibuffer plugin
" let g:miniBufExplMapWindowNavVim = 1
" let g:miniBufExplMapWindowNavArrows = 1
" let g:miniBufExplMapCTabSwitchBufs = 1
" let g:miniBufExplModSelTarget = 1 

"Jumping between header and implementation
"a.vim http://www.vim.org/scripts/script.php?script_id=31
" :A switches to the header file corresponding to the current file being
" edited (or vise versa)
" :AS splits and switches
" :AV vertical splits and switches
" :AT new tab and switches
" :AN cycles through matches
" :IH switches to file under cursor
" :IHS splits and switches
" :IHV vertical splits and switches
" :IHT new tab and switches
" :IHN cycles through matches
" <Leader>ih switches to file under cursor
" <Leader>is switches to the alternate file of file under cursor (e.g. on
" <foo.h> switches to foo.cpp)
" <Leader>ihn cycles through matches 
"
" Settings for objective-c
let g:alternateExtensions_m = "h"
let g:alternateExtensions_h = "m,c,cpp"

"erlang stuff

let g:erlangFold=0

"Ruby stuff
fun BenIndent()
    let oldLine=line('.')
    " our text (whole file) is passed via STDIN (%) to script name, and the output is
    " placed in current buffer (STDOUT)
    if g:IndentStyle == "C"
        :%!indent --gnu-style --no-tabs --indent-level 8 --case-indentation 0 --brace-indent 0 --comment-delimiters-on-blank-lines --start-left-side-of-comments --format-all-comments --format-first-column-comments
    elseif g:IndentStyle == "perl"
        :%!perltidy -gnu
    elseif g:IndentStyle == "html"
        :%!tidy -quiet -utf8 -indent -clean -asxhtml
    elseif g:IndentStyle == "php"
        :%!tidy -quiet -utf8 -indent -clean 
    elseif g:IndentStyle == "ruby"
        :%!~/.vim/rubybeautifier.rb
    endif
    exe ':' . oldLine
endfun
map -- :call BenIndent()<CR>

augroup ruby
    if !exists("autocommands_ruby_loaded")
        let autocommands_ruby_loaded = 1
        au BufReadPre *.rb set sw=3 sts=3 nu | let IndentStyle = "ruby"
        
        au BufNewFile *.rb 0r ~/.vim/skeleton.rb | let IndentStyle = "ruby"
    endif

    augroup myfiletypes
    autocmd!
    autocmd FileType ruby,eruby,yaml set ai sw=2 sts=2 et


augroup END 

" For commenting erlang files
au FileType erlang vnoremap <f4> :s/^/%<cr>
au FileType erlang vnoremap <f5> :s/%<cr>

au FileType python vnoremap <f4> :s/^/#<cr>
au FileType python vnoremap <f5> :s/#<cr>
