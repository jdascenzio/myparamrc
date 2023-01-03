packadd! CtrlP

" run buffer explorer on <c-p>
let g:ctrlp_cmd = 'CtrlPBuffer'

" If 'cscopetag' is set, the commands ":tag" and CTRL-] as well as "vim -t"
" will always use :cstag instead of the default :tag behavior
set cscopetag

" Vim5 and later versions support syntax highlighting. Uncommenting the next
" line enables syntax highlighting by default.
syntax on
let g:zenburn_alternate_Error=1
let g:zenburn_high_Contrast=1
let g:zenburn_old_Visual = 1
let g:zenburn_alternate_Visual = 1

colors zenburn

set nocp
filetype plugin on

" completion
"autocmd FileType python set omnifunc=pythoncomplete#Complete
"autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
"autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
"autocmd FileType css set omnifunc=csscomplete#CompleteCSS
"autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
"autocmd FileType php set omnifunc=phpcomplete#CompletePHP
" autocmd FileType c set omnifunc=cppcomplete#CompleteCPP
" OmniCppComplete
" let OmniCpp_NamespaceSearch = 1
" let OmniCpp_GlobalScopeSearch = 1
" let OmniCpp_ShowAccess = 1
" let OmniCpp_MayCompleteDot = 1
" let OmniCpp_MayCompleteArrow = 1
" let OmniCpp_MayCompleteScope = 1
" let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]

" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest,preview

" trailling white spaces errors
" if c_no_trail_space_error is not set, end line spaces are highlighted
" if c_no_tab_space_error is not set, spaces followed by tabs are highlighted
let c_space_errors = 1

nnoremap <F5> :make -j10<CR>
nnoremap <F6> :make tags<CR>
nnoremap <F7> :let sha=expand("<cword>")<CR>:call GitShow(sha)<CR>
function! GitShow(sha)
	let sha = a:sha
	execute 'vsplit '.sha.'.patch'
	execute '%!git show '.sha
endfunction

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

" python
autocmd Filetype python set tabstop=4
autocmd Filetype python set softtabstop=4
autocmd Filetype python set shiftwidth=4
autocmd Filetype python set textwidth=79
autocmd FileType python set expandtab
autocmd FileType python set autoindent
autocmd FileType python set fileformat=unix

fu! CleanCode()
	%s/\+//g
	%s/[	 ]\+$//
endf

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

fu! CS_paratronic()
	set tabstop=4
	set shiftwidth=4
 	set noexpandtab
	set cinoptions=(0
        call SYNTAX_C_HL()
	set makeprg=make\ -j10
	noremap <F5> :make<CR>
	noremap <F6> :make tags<CR>
	noremap <F7> :make flash<CR>
endf

fu! CS_zephyr()
	set noexpandtab                         " use tabs, not spaces
	set tabstop=8                           " tabstops of 8
	set shiftwidth=8                        " indents of 8
	set softtabstop=8
	set textwidth=100
	set formatoptions=tcqlron
	set cindent
	set cinoptions=:0,l1,t0,g0,(0
	set makeprg=west\ build
	noremap <F5> :make<CR>
	noremap <F6> :!west tags<CR>
	noremap <F7> :!west flash<CR>
	set colorcolumn=+1
	highlight ColorColumn ctermbg=lightgrey
endf

" regles par defaut
call CS_zephyr()

" interactive shell to get bash aliases
set shell=bash

" set cmdline history depth
set history=100

" set encoding
set encoding=utf-8

let g:netrw_browsex_viewer= "gnome-open"

" hide by default
let g:netrw_list_hide="\\(^\\|\\s\\s\\)\\zs\\.\\S\\+"

" sort case-insensitive
let g:netrw_sort_options = "i"
