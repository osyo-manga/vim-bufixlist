if exists('g:loaded_bufixlist')
  finish
endif
let g:loaded_bufixlist = 1

let s:save_cpo = &cpo
set cpo&vim


command! -nargs=1
\	Bexpr call bufixlist#expr("%", <args>)

command! -nargs=1
\	Bgetexpr call bufixlist#getexpr("%", <args>)

command! -nargs=*
\	Bopen lopen <args>

command!
\	Bclose lclose

command! -nargs=*
\	Bwindow lwindow <args>


augroup bufixlist
	autocmd!
	autocmd BufEnter * call bufixlist#redraw("%")
augroup END


let &cpo = s:save_cpo
unlet s:save_cpo
