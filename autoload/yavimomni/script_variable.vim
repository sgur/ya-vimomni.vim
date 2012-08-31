" Script-local variables

function! yavimomni#script_variable#init()
  let s:scriptlocals = map(keys(s:), 'substitute(v:val, "^", "s:", "g")')
endfunction


function! yavimomni#script_variable#get()
  " return s:
  return map(keys(s:), 'substitute(v:val, "^", "s:", "g")')
endfunction
