let s:save_cpo = &cpo
set cpo&vim

let s:outputter = quickrun#outputter#buffered#new()
let s:outputter.config = {
\	'errorformat': '',
\	'open_cmd': 'cwindow',
\ }

let s:outputter.init_buffered = s:outputter.init

function! s:outputter.init(session)
	call self.init_buffered(a:session)

	let self.config.errorformat
\		= !empty(self.config.errorformat) ? self.config.errorformat
\		: !empty(&l:errorformat)          ? &l:errorformat
\		: &g:errorformat
endfunction


function! s:outputter.finish(session)
	try
		let errorformat = &g:errorformat
		let &g:errorformat = self.config.errorformat

		Bgetexpr self._result
		silent execute self.config.open_cmd
		for winnr in range(1, winnr('$'))
			if getwinvar(winnr, '&buftype') ==# 'quickfix'
				call setwinvar(winnr, 'quickfix_title', 'quickrun: ' .
				\	 join(a:session.commands, ' && '))
				break
			endif
		endfor
	finally
" 		cwindow
		let &g:errorformat = errorformat
	endtry
endfunction


function! quickrun#outputter#bufixlist#new()
	return deepcopy(s:outputter)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
