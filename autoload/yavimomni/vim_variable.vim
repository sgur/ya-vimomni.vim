" Vim variables

function! yavimomni#vim_variable#init()
  let s:vim_vars = map(keys(v:), 'substitute(v:val, "^", "v:", "g")')
endfunction


function! yavimomni#vim_variable#get()
  return s:vim_vars
endfunction
