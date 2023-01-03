packadd! CtrlP
packadd! gitgutter
packadd! bufexplorer
packadd! omnicppcomplete
packadd! po

syntax on

if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif
endif

if has("autocmd")
  filetype indent on
endif

" completion

set nocp
filetype plugin on

set tags+=~/.vim/tags/linux
set incsearch		" Incremental search
set hlsearch		" highlight search
set autowrite		" Automatically save before commands like :next and :make

" trailling white spaces errors
" if c_no_trail_space_error is not set, end line spaces are highlighted
" if c_no_tab_space_error is not set, spaces followed by tabs are highlighted
let c_space_errors = 1

function! GitShow(sha)
	let sha = a:sha
	execute 'vsplit '.sha.'.patch'
	execute '%!git show '.sha
endfunction

function! GenerateLinuxTags()
	execute ':!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q	--language-force=C++ -f ~/.vim/tags/linux.tags /usr/include/linux/ /usr/include/stdlib.h /usr/include/string.h /usr/include/sys/'
endfunction

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

fu! CleanCode()
	%s/
\+//g
	%s/[	 ]\+$//
endf

" set cmdline history depth
set history=100

let g:netrw_browsex_viewer= "gnome-open"

" hide by default
let g:netrw_list_hide="\\(^\\|\\s\\s\\)\\zs\\.\\S\\+"

" sort case-insensitive
let g:netrw_sort_options = "i"
