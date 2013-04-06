let s:save_cpo = &cpo
set cpo&vim


function! bufixlist#set(expr, qflist)
	let bufnr = bufnr(a:expr)
	if !bufexists(bufnr)
		return -1
	endif
	call setbufvar(bufnr, "bufferfixlist", a:qflist)

	let winnr = bufwinnr(bufnr)
	if winnr
		return setloclist(winnr, a:qflist)
	endif
	return 0
endfunction

function! bufixlist#get(expr)
	let result = getbufvar(a:expr, "bufferfixlist")
	return type(result) == type("") ? [] : result
endfunction


function! bufixlist#redraw(expr)
	let qflist =  bufixlist#get(a:expr)
	if !empty(qflist)
		call setloclist(winnr(), qflist)
	endif
endfunction


function! s:expr_cmd(bufexpr, expr, cmd)
	let old = getloclist(1)
	try
		execute a:cmd "a:expr"
	finally
		let new = getloclist(1)
		call setloclist(1, old)
	endtry
	return bufixlist#set(a:bufexpr, new)
endfunction


function! bufixlist#expr(bufexpr, expr)
	return s:expr_cmd(a:bufexpr, a:expr, "lexpr")
endfunction


function! bufixlist#getexpr(bufexpr, expr)
	return s:expr_cmd(a:bufexpr, a:expr, "lgetexpr")
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
