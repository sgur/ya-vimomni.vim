" Global variables

function! yavimomni#global_variable#init()
  let s:globals = map(keys(g:), 'substitute(v:val, "^", "g:", "g")')
  echomsg 'Global variables' len(s:globals)
endfunction


function! yavimomni#global_variable#get(arglead)
  let retval = []
  for g in s:globals
    try
      let explanation = string(get(g:, substitute(g, '^g:', '', '')))
    catch /^Vim\%((\a\+)\)\=:E724/  " for circular references
      let explanation = '... (Circular references)'
    endtry
    call add(retval, {'word': g, 'menu' : explanation})
  endfor
  return filter(copy(retval), 'stridx(v:val.word, a:arglead) >= 0')
endfunction
