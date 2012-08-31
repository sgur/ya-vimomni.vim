" Script-local variables
" FIMXE: won't work

function! yavimomni#script_variable#init()
endfunction


function! yavimomni#script_variable#get()
  let lines = getline(1, '$')
  return map(filter(map(lines,
        \ 'matchstr(v:val, "let\\s\\+s:\\zs\\k\\+\\ze\\s*=")'),
        \ '!empty(v:val)'),
        \ 'substitute(v:val, "^", "s:", "")')
endfunction
