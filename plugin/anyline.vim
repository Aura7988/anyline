" =============================================================================
" Filename: plugin/anyline.vim
" Author: Aura <aura8897@gmail.com>
" License: MIT License
" =============================================================================

if exists('g:anyline_loaded') || v:version < 700
  finish
endif
let g:anyline_loaded = 1

let s:save_cpo = &cpo
set cpo&vim

let s:oldpath = 'o'
let s:oldbranch = ''

function! BranchName()
	let l:newpath = expand('%:p:h')
	if s:oldpath == l:newpath
		return s:oldbranch
	endif

	let s:oldpath = l:newpath
	let l:git = 'git -C '.l:newpath
	let l:sha = system(l:git.' rev-parse HEAD 2> /dev/null')
	if empty(l:sha)
		let s:oldbranch = ''
		return ''
	endif

	let l:b = system(l:git.' symbolic-ref --short -q HEAD || '.l:git.' describe --tags --exact-match HEAD 2> /dev/null')
	if empty(l:b)
		let s:oldbranch = ' ·  '.l:sha[:6]
	else
		let s:oldbranch = ' ·  '.trim(l:b)
	endif
	return s:oldbranch
endfunction

let s:mode_map = {
	\ 'n':      'NORMAL',
	\ 'i':      'INSERT',
	\ 'R':      'REPLACE',
	\ 'v':      'VISUAL',
	\ 'V':      'V-LINE',
	\ "\<C-v>": 'V-BLOCK',
	\ 'c':      'COMMAND',
	\ 's':      'SELECT',
	\ 'S':      'S-LINE',
	\ "\<C-s>": 'S-BLOCK',
	\ 't':      'TERMINAL'
	\ }

function! ModePasteBranch()
	let l:mpb  = get(s:mode_map, mode(), '')
	let l:mpb .= &paste ? ' · PASTE' : ''
	let l:mpb .= BranchName()
	return l:mpb
endfunction

set statusline= 
set statusline+=%#C1#\ %{ModePasteBranch()}\  
set statusline+=%#C2#\ %{&ro?'\ ':''}%t%m\  
set statusline+=%#C3#%=%<
set statusline+=%#C5#\ %{&ft!=''?&ft.'\ ·\ ':''}%{&fenc!=''?&fenc:&enc}[%{&ff}]\  
set statusline+=%#C7#\ %l,%c%V\ %p%%\  

hi C1 ctermbg=231 ctermfg=21
hi C2 ctermbg=21  ctermfg=231
hi C3 ctermbg=236 ctermfg=21
hi C4 ctermbg=236 ctermfg=243
hi C5 ctermbg=243 ctermfg=233
hi C6 ctermbg=243 ctermfg=253
hi C7 ctermbg=253 ctermfg=233

let &cpo = s:save_cpo
unlet s:save_cpo
