" =============================================================================
" Filename: plugin/anyline.vim
" Author:   Aura <aura8897@gmail.com>
" License:  MIT License
" =============================================================================

if exists('g:anyline_loaded') | finish | endif
let g:anyline_loaded = 1

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

function AStatusLine() abort
	let stl = '%#C0# ' .. get(s:mode_map, mode(), '') .. (&paste ? ' · PASTE' : '')
	let l:b = get(b:, 'gitsigns_head', '')
	if empty(l:b)
		let stl ..= ' %#C1#'
	else
		let l:vcs = '  ' .. l:b
		let l:gs = get(b:, 'gitsigns_status', '')
		if len(l:gs) | let l:vcs ..= ' ' .. l:gs | endif
		let stl ..= ' %#C2#%#C3#' .. l:vcs .. ' %#C4#'
	endif
	let stl ..= "%#C5# %{&ro?' ':''}%t%m "
	let info = get(b:, 'coc_diagnostic_info', {})
	if len(info)
		let msgs = []
		if get(info, 'error', 0) | call add(msgs, '' . info['error']) | endif
		if get(info, 'warning', 0) | call add(msgs, '' . info['warning']) | endif
		let stl ..= join(msgs, ' ')
	endif
	return stl .. "%=%<%{&fenc}[%{&ff}] %#C6#%#C0# %l,%c%V %p%% "
endfunction

function ATabLine() abort
	let tal = '%#C7#'
	let ct = tabpagenr()
	let lt = tabpagenr('$')
	for i in range(1, lt)
		" let tn = ' ╰' .. i .. ' ' .. fnamemodify(bufname(tabpagebuflist(i)[tabpagewinnr(i) - 1]), ':t') .. ' '
		let tn = ' └' .. i .. ' ' .. fnamemodify(bufname(tabpagebuflist(i)[tabpagewinnr(i) - 1]), ':t') .. ' '
		let tal ..= ct == i ? '%#C8#' .. tn .. '%#C7#' : tn
	endfor
	return tal
endfunction

" 107 152 222 b #6B98DE
" 120 174 114 g #78AE72
hi C0 guibg=#6B98DE guifg=White
hi C1 guifg=#6B98DE guibg=LightGray
hi C2 guibg=#78AE72 guifg=#6B98DE
hi C3 guibg=#78AE72 guifg=White
hi C4 guifg=#78AE72 guibg=LightGray
hi C5 guibg=LightGray guifg=Black
hi C6 guibg=#6B98DE guifg=LightGray
hi C7 guibg=NONE guifg=LightGray
hi C8 guibg=NONE guifg=Orange

set statusline=%!AStatusLine()
set tabline=%!ATabLine()
