" All system-wide defaults are set in $VIMRUNTIME/debian.vim (usually just
" /usr/share/vim/vimcurrent/debian.vim) and sourced by the call to :runtime
" you can find below.  If you wish to change any of those settings, you should
" do it in this file (/etc/vim/vimrc), since debian.vim will be overwritten
" everytime an upgrade of the vim packages is performed.  It is recommended to
" make changes after sourcing debian.vim since it alters the value of the
" 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim

" Uncomment the next line to make Vim more Vi-compatible
" NOTE: debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
"set compatible

" Vim5 and later versions support syntax highlighting. Uncommenting the next
" line enables syntax highlighting by default.
syntax on

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
if has("gui_running")
  set background=light
else
  set background=dark
endif

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif
endif

" Uncomment the following to have Vim load indentation rules according to the
" detected filetype. Per default Debian Vim only load filetype specific
" plugins.
if has("autocmd")
  filetype indent on
endif

" completion
set nocp
filetype plugin on
"autocmd FileType python set omnifunc=pythoncomplete#Complete
"autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
"autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
"autocmd FileType css set omnifunc=csscomplete#CompleteCSS
"autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
"autocmd FileType php set omnifunc=phpcomplete#CompletePHP
"autocmd FileType c set omnifunc=ccomplete#Complete
" OmniCppComplete
let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_MayCompleteDot = 1
let OmniCpp_MayCompleteArrow = 1
let OmniCpp_MayCompleteScope = 1
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest,preview
set tags+=~/.vim/tags/stl
set tags+=~/.vim/tags/xml2
set tags+=~/.vim/tags/sema
map <C-t> :!rm tags<CR>:!ctags -R --sort=yes --c++-kinds=+pl --fields=+iaS --extra=+q .<CR>

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
"set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
"set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
set incsearch		" Incremental search
set hlsearch		" highlight search
set autowrite		" Automatically save before commands like :next and :make
"set hidden             " Hide buffers when they are abandoned
"set mouse=a		" Enable mouse usage (all modes) in terminals
"set modelines=5
set modeline
"set foldmethod=syntax " fold regarding syntax
set tabstop=8 " always keep that value

" trailling white spaces errors
" if c_no_trail_space_error is not set, end line spaces are highlighted
" if c_no_tab_space_error is not set, spaces followed by tabs are highlighted
let c_space_errors = 1

" Source a global configuration file if available
" XXX Deprecated, please move your changes here in /etc/vim/vimrc
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

" mes maps
nmap <C-^>t :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
nmap <C-^>v :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
nnoremap <F5> :make<CR>
function! GitShow(sha)
	let sha = a:sha
	execute 'vsplit '.sha.'.patch'
	execute '%!git show '.sha
endfunction

if !exists("autocommands_loaded")
	let autocommands_loaded = 1
	augroup C
		autocmd BufRead *.c,*.h set cindent
	augroup END
endif

" syntax highlight
fu! SYNTAX_C_HL()
    if &expandtab
        hi ErrorLeadTab ctermbg=Red guibg=Red
        hi ErrorLeadSpace NONE
    else
        hi ErrorLeadTab NONE
        hi ErrorLeadSpace ctermbg=Red guibg=Red
    endif
endf

" kernel coding style
fu! CS_kernel()
	set noexpandtab 
	set cinwords-=switch
	set softtabstop=8
	set shiftwidth=8
	set cinoptions=:0,l1,t0,(0,g0
        call SYNTAX_C_HL()
        hi Error80 ctermbg=Red guibg=Red
	match Error80 /.\%>100v/ " highlight anything past 100 in red
endf

" Setup for the GNU coding format standard
fu! CS_gnu()
	" au! FileType cpp setlocal
	set softtabstop=4
	set shiftwidth=4
	set expandtab
	set cinoptions={.5s,:.5s,+.5s,t0,g0,^-2,e-2,n-2,p2s,(0,=.5s
	set formatoptions=croql cindent
        call SYNTAX_C_HL()
endf

" mib coding style
fu! CS_mib()
	set softtabstop=4
	set shiftwidth=4
	set expandtab
	set cinoptions=:0,(0
        call SYNTAX_C_HL()
endf

" adeneo coding style
fu! CS_adeneo()
	set tabstop=4
	set shiftwidth=4
 	set noexpandtab
	set cinoptions=(0
        call SYNTAX_C_HL()
endf

" mib coding style
fu! CS_ws()
	set softtabstop=2
	set shiftwidth=2
	set expandtab
	set cinoptions=:0,(0
        call SYNTAX_C_HL()
endf




" ucarp
"set softtabstop=4
"set shiftwidth=4
"set expandtab
"set cinoptions=:0,(0

" standart
"set softtabstop=8
"set shiftwidth=8
"set noexpandtab
"set cindent

fu! CleanCode()
	%s/\+//g
	%s/[	 ]\+$//
endf

fu! MIB_syntax()
	source /usr/share/vim/vim71/syntax/mib.vim
endf

fu! DIFF_syntax()
	source /usr/share/vim/vimcurrent/syntax/diff.vim
endf

" regles par defaut
call CS_adeneo()

" interactive shell to get bash aliases
"set shell=/bin/bash\ --rcfile\ ~/.bash_profile
set shell=/bin/bash\ --login

" exVim
"let $EX_DEV = '~/exDev'
"source ~/.vimrc_ex

" set cmdline history depth
set history=100

" set encoding
set encoding=utf-8
set fileencoding=utf-8
