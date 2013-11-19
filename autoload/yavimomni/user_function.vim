" User-define functions

function! yavimomni#user_function#init()
  let s:scriptnames = s:scriptnames()
  redir => functions
  silent function
  redir END
  let s:functions = map(split(functions, '\n'),
        \ 'matchstr(v:val, "function\\s\\zs.\\+\\ze(")')
  let s:initialized = 1
endfunction


function! yavimomni#user_function#get(arglead)
  if !s:initialized
    call yavimomni#user_function#init()
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
let s:initialized = 0

call yavimomni#user_function#init()

augroup yavimomni_sourcepre_user_command
  autocmd!
  autocmd SourcePre *  let s:Initialized = 0
augroup END
