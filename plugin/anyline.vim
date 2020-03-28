" =============================================================================
" Filename: plugin/gitbranch.vim
" Author: itchyny
" License: MIT License
" Last Change: 2015/05/12 08:16:47.
" =============================================================================

if exists('g:loaded_gitbranch') || v:version < 700
  finish
endif
let g:loaded_gitbranch = 1

let s:save_cpo = &cpo
set cpo&vim

augroup GitBranch
  autocmd!
  autocmd BufNewFile,BufReadPost * call gitbranch#detect(expand('<amatch>:p:h'))
  autocmd BufEnter * call gitbranch#detect(expand('%:p:h'))
augroup END

function! ModePasteBranch()
	let l:mode_map = {
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
	let l:mpb  = get(l:mode_map, mode(), '')
	let l:mpb .= &paste ? ' · PASTE' : ''
	let l:mpb .= g:gitbranch ? (' ·  ' . gitbranch#name()) : ''
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
