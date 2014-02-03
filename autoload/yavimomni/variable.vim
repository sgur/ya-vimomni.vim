" Global variables


function! yavimomni#variable#init()
  let vim_vars = map(keys(v:), 'substitute(v:val, "^", "v:", "")')
  let s:variables = vim_vars
endfunction


function! yavimomni#variable#get(arglead)
  let global_vars = map(keys(g:), 'substitute(v:val, "^", "g:", "")')
  let win_vars = map(keys(w:), 'substitute(v:val, "^", "w:", "")')
  let buf_vars = map(keys(b:), 'substitute(v:val, "^", "b:", "")')
  let retval = []
  for var in s:variables + global_vars + win_vars + buf_vars
    let expl = string(s:get_explanation(var))
    call add(retval, {'word': var
          \ , 'kind' : 'variable'
          \ , 'menu' : yavimomni#util#truncate(expl, yavimomni#util#truncate_length())})
  endfor
  return copy(retval)
endfunction


function! s:get_explanation(var_name)
  try
    if a:var_name =~# '^g:'
      return get(g:, substitute(a:var_name, '^g:', '', ''))
    elseif a:var_name =~# '^v:'
      return get(v:, substitute(a:var_name, '^v:', '', ''))
    elseif a:var_name =~# '^w:'
      return get(w:, substitute(a:var_name, '^w:', '', ''))
    elseif a:var_name =~# '^b:'
      return get(b:, substitute(a:var_name, '^b:', '', ''))
    else
      return ''
    endif
  catch /^Vim\%((\a\+)\)\=:E724/  " for circular references
    return '... (Circular references)'
  endtry
endfunction


" Initialization

call yavimomni#variable#init()
