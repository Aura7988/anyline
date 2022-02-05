" =============================================================================
" Filename: plugin/anyline.vim
" Author:   Aura <aura8897@gmail.com>
" License:  MIT License
" =============================================================================

if exists('g:anyline_loaded') | finish | endif
let g:anyline_loaded = 1

let s:save_cpo = &cpo
set cpo&vim

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

function! Diagnostic() abort
	let info = get(b:, 'coc_diagnostic_info', {})
	if empty(info) | return '' | endif
	let msgs = [' ']
	if get(info, 'error', 0)
		call add(msgs, '' . info['error'])
	endif
	if get(info, 'warning', 0)
		call add(msgs, '' . info['warning'])
	endif
	return join(msgs, ' ')
endfunction

function! ModeVCS() abort
	let l:mode = '%#C0# ' . get(s:mode_map, mode(), '') . (&paste ? ' · PASTE' : '')
	let l:b = get(b:, 'gitsigns_head', '')
	if empty(l:b) | return l:mode . ' %#C1#' | endif
	let l:vcs = '  ' . l:b
	let l:gs = get(b:, 'gitsigns_status', '')
	if len(l:gs)
		let l:vcs .= ' ' . l:gs
	endif
	return l:mode . ' %#C2#%#C3#' . l:vcs .' %#C4#'
endfunction

" 107 152 222 b #6B98DE
" 120 174 114 g #78AE72
hi C0 guibg=#6B98DE guifg=White
hi C1 guifg=#6B98DE guibg=LightGray
hi C2 guibg=#78AE72 guifg=#6B98DE
hi C3 guibg=#78AE72 guifg=White
hi C4 guifg=#78AE72 guibg=LightGray
hi C5 guibg=LightGray guifg=Black
hi C6 guifg=LightGray guibg=#E8EBF0
hi C7 guibg=#E8EBF0 guifg=White
hi C8 guifg=#E8EBF0 guibg=LightGray
hi C9 guibg=#6B98DE guifg=LightGray

set statusline=%{%ModeVCS()%}
set statusline+=%#C5#\ %{&ro?'\ ':''}%t%m%{Diagnostic()}\ %#C6#
set statusline+=%#C7#%=%<%#C8#
set statusline+=%#C5#\ %{&ft!=''?&ft.'\ ·\ ':''}%{&fenc!=''?&fenc:&enc}[%{&ff}]\ %#C9#
set statusline+=%#C0#\ %l,%c%V\ %p%%\ 

let &cpo = s:save_cpo
unlet s:save_cpo
