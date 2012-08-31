" User-define functions

function! yavimomni#user_function#init()
  redir => functions
  silent function
  redir END
  let s:functions = map(map(split(functions, '\n'),
        \ 'matchstr(v:val, "function\\s\\zs.\\+(")'),
        \ 'substitute(v:val, "<SNR>\\d\\+_", "s:", "g")')
endfunction


function! yavimomni#user_function#get()
  return s:functions
endfunction
