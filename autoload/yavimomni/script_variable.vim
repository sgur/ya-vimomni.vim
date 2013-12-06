" Script-local variables

function! yavimomni#script_variable#init()
endfunction


function! yavimomni#script_variable#get(arglead)
  return map(filter(map(getline(1, '$'),
        \ 'matchstr(v:val, "let\\s\\+s:\\zs\\k\\+\\ze\\s*=")'),
        \ '!empty(v:val)'),
        \ '{"word": substitute(v:val, "^", "s:", ""), "menu": "[V]"}')
endfunction


" Initialization

call yavimomni#script_variable#init()
