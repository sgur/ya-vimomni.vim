let s:save_cpo = &cpo
set cpo&vim

" Options

function! yavimomni#option#init()
  redir => raw
  silent set all
  redir END
  let options = map(filter(
        \ map(split(raw, '\s\{2,}\|\n')[1:], 'split(v:val, "=", 1)[0]'),
        \ '!empty(v:val) && exists("&".v:val)'),
        \ 'substitute(v:val, "^no", "", "")')
  let s:options = options
  echomsg 'Options' len(s:options)
endfunction


function! yavimomni#option#get(arglead)
  let prefix = matchstr(a:arglead, '^[gl]:')
  let arglead = substitute(a:arglead, prefix, '', '')
  return map(filter(copy(s:options),  'stridx(v:val, arglead) >= 0')
        \ , '{"word" : prefix . v:val, "menu" : eval("&".prefix . v:val)}')
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
