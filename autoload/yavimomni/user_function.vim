" User-define functions

function! yavimomni#user_function#init()
  let s:scriptnames = s:scriptnames()
  redir => functions
  silent function
  redir END
  let s:functions = map(split(functions, '\n'),
        \ 'matchstr(v:val, "function\\s\\zs.\\+(")')
endfunction


function! yavimomni#user_function#get(arglead)
  let scriptnames = s:scriptnames()
  if len(scriptnames) > len(s:scriptnames)
    call yavimomni#user_function#init()
  endif
  let fname = fnamemodify(expand("%"), ":p")
  let _ = copy(s:functions)
  if has_key(s:scriptnames, fname)
    let sid = s:scriptnames[fname]
    call map(_, 'substitute(v:val, "<SNR>".sid."_", "s:", "")')
  endif
  call filter(_, 'stridx(v:val, "<SNR>") == -1')

  return yavimomni#util#convert_list_candidates(
      \ filter(_, 'stridx(v:val, a:arglead) == 0'))
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


" Initialization

call yavimomni#user_function#init()
