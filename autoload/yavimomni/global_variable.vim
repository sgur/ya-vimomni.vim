" Global variables

function! yavimomni#global_variable#init()
  let s:globals = map(keys(g:), 'substitute(v:val, "^", "g:", "g")')
endfunction


function! yavimomni#global_variable#get()
  let retval = []
  for g in s:globals
    try
      let explanation = string(get(g:, substitute(g, '^g:', '', '')))
    catch /^Vim\%((\a\+)\)\=:E724/  " for circular references
      let explanation = '... (Circular references)'
    endtry
    call add(retval, {'word': g, 'menu' : explanation})
  endfor
  return retval
endfunction
