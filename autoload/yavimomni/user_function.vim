" User-define functions

function! yavimomni#user_function#init()
  call s:scriptnames()
  redir => functions
  silent function
  redir END
  let s:functions = map(split(functions, '\n'),
        \ 'matchstr(v:val, "function\\s\\zs.\\+(")')
endfunction


function! s:scriptnames()
  redir => scriptnames
  silent scriptnames
  redir END
  let s:scriptnames = {}
  call map(map(split(scriptnames, '\n'), 'split(v:val, ": ")'),
        \ 'extend(s:scriptnames, {fnamemodify(v:val[1], ":p") : v:val[0]})')
endfunction


function! yavimomni#user_function#get()
  let sid = s:scriptnames[fnamemodify(expand('%'), ':p')]
  return filter(map(s:functions,
        \ 'substitute(v:val, "<SNR>".sid."\\+_", "s:", "g")'),
        \ 'stridx(v:val, "<SNR>")')
endfunction
