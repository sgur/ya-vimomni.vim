" Global variables

function! yavimomni#global_variable#init()
  let s:globals = map(keys(g:), 'substitute(v:val, "^", "g:", "g")')
endfunction


function! yavimomni#global_variable#get()
  return s:globals
endfunction
