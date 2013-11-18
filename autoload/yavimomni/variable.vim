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
    let explanation = s:get_explanation(var)
    call add(retval, {'word': var, 'menu' : explanation})
  endfor
  return filter(copy(retval), 'stridx(v:val.word, a:arglead) == 0')
endfunction


function! s:get_explanation(var_name)
  try
    if a:var_name =~# '^g:'
      return string(get(g:, substitute(a:var_name, '^g:', '', '')))
    elseif a:var_name =~# '^v:'
      return string(get(v:, substitute(a:var_name, '^v:', '', '')))
    elseif a:var_name =~# '^w:'
      return string(get(w:, substitute(a:var_name, '^w:', '', '')))
    elseif a:var_name =~# '^b:'
      return string(get(b:, substitute(a:var_name, '^b:', '', '')))
    else
      return ''
    endif
  catch /^Vim\%((\a\+)\)\=:E724/  " for circular references
    return '... (Circular references)'
  endtry
endfunction


" Initialization

call yavimomni#variable#init()
