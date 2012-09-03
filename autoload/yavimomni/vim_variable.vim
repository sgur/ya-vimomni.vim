" Vim variables

function! yavimomni#vim_variable#init()
  let s:vim_vars = map(keys(v:), 'substitute(v:val, "^", "v:", "g")')
  echomsg 'Vim variables' len(s:vim_vars)
endfunction


function! yavimomni#vim_variable#get(arglead)
  return filter(copy(s:vim_vars), 'stridx(v:val, a:arglead) >= 0')
endfunction
