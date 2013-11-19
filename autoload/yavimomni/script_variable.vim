" Script-local variables

function! yavimomni#script_variable#init()
endfunction


function! yavimomni#script_variable#get(arglead)
  let _ = map(filter(map(getline(1, '$'),
        \ 'matchstr(v:val, "let\\s\\+s:\\zs\\k\\+\\ze\\s*=")'),
        \ '!empty(v:val)'),
        \ '{"word": substitute(v:val, "^", "s:", ""), "menu": "[variable]"}')

  return filter(_, 'stridx(v:val.word, a:arglead) == 0')
endfunction


" Initialization

call yavimomni#script_variable#init()
