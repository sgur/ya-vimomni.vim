" Global variables


function! yavimomni#variable#init()
  let global_vars = map(keys(g:), 'substitute(v:val, "^", "g:", "g")')
  let vim_vars = map(keys(v:), 'substitute(v:val, "^", "v:", "g")')
  let s:variables = global_vars + vim_vars
endfunction


function! yavimomni#variable#get(arglead)
  let win_vars = map(keys(w:), 'substitute(v:val, "^", "w:", "g")')
  let buf_vars = map(keys(b:), 'substitute(v:val, "^", "b:", "g")')
  let retval = []
  for var in s:variables + win_vars + buf_vars
    let Explanation = s:get_explanation(var)
    call add(retval, s:map_func(var, Explanation))
    unlet Explanation
  endfor
  return filter(copy(retval), 'stridx(v:val.word, a:arglead) == 0')
endfunction



function! s:map_func(var, val)
  let val = string(a:val)
  if type(a:val) == type([])
    return {'word': a:var, 'menu' : '[...]', 'info' : val}
  elseif type(a:val) == type({})
    return {'word': a:var, 'menu' : '{...}', 'info' : val}
  else
    return {'word': a:var, 'menu' : val}
  endif
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
