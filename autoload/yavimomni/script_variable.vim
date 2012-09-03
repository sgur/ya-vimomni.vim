" Script-local variables
" FIMXE: won't work

function! yavimomni#script_variable#init()
endfunction


function! yavimomni#script_variable#get(arglead)
  let vars =  map(filter(map(getline(1, '$'),
        \ 'matchstr(v:val, "let\\s\\+s:\\zs\\k\\+\\ze\\s*=")'),
        \ '!empty(v:val)'),
        \ 'substitute(v:val, "^", "s:", "")')
  return filter(copy(vars), 'stridx(v:val, a:arglead) >= 0')
endfunction
