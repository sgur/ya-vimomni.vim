" User-define functions

function! yavimomni#user_function#init()
  let s:scriptnames = s:scriptnames()
  let s:functions = s:functions()
endfunction


function! yavimomni#user_function#get(arglead)
  let scriptnames = s:scriptnames()
  if len(scriptnames) > len(s:scriptnames)
    let s:scriptnames = scriptnames
    let s:functions = s:functions()
  endif
  let fname = fnamemodify(expand("%"), ":p")
  let _ = copy(s:functions)
  if has_key(s:scriptnames, fname)
    let sid = s:scriptnames[fname]
    call map(_, 'substitute(v:val, "<SNR>".sid."_", "s:", "")')
  endif
  call filter(_, 'stridx(v:val, "<SNR>") == -1')

  return map(_, '{"word": v:val, "abbr": v:val . "()", "menu": "[function]"}')
endfunction



function s:functions()
  redir => functions
  silent function
  redir END
  return map(split(functions, '\n'),
        \ 'matchstr(v:val, "function\\s\\zs.\\+\\ze(")')
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


call yavimomni#user_function#init()
