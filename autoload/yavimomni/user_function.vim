" User-define functions

function! yavimomni#user_function#init()
  let s:scriptnames = s:scriptnames()
  redir => functions
  silent function
  redir END
  let s:functions = map(split(functions, '\n'),
        \ 'matchstr(v:val, "function\\s\\zs.\\+(")')
endfunction


function! yavimomni#user_function#get()
  let scriptnames = s:scriptnames()
  if len(scriptnames) > len(s:scriptnames)
    call yavimomni#user_function#init()
  endif
  let sid = s:scriptnames[fnamemodify(expand('%'), ':p')]
  return filter(map(s:functions,
        \ 'substitute(v:val, "<SNR>".sid."\\+_", "s:", "g")'),
        \ 'stridx(v:val, "<SNR>")')
endfunction


function! s:scriptnames()
  redir => scriptnames
  silent scriptnames
  redir END
  let _ = {}
  call map(map(split(scriptnames, '\n'), 'split(v:val, ": ")'),
        \ 'extend(_, {fnamemodify(v:val[1], ":p") : eval(v:val[0])})')
  return _
endfunction
