" User-define functions

function! yavimomni#user_function#init()
  let s:scriptnames = s:scriptnames()
  let s:functions = s:functions()
endfunction


function! yavimomni#user_function#get(arglead)
  if g:yavimomni_enable_autoload_functions &&
        \ match(s:functions, '^' . a:arglead) == -1
    let path = substitute(a:arglead, '.*\zs#$', '', '')
    try
      execute 'runtime autoload/' . substitute(path, '#', '/', 'g') . '.vim'
    catch /^Vim\%((\a\+)\)\=:E121/
    catch /^Vim\%((\a\+)\)\=:E122/
      echomsg v:exception
    finally
    endtry
  endif

  let scriptnames = s:scriptnames()
  if len(scriptnames) > len(s:scriptnames)
    let s:scriptnames = scriptnames
    let s:functions = s:functions()
  endif
  let fname = fnamemodify(expand("%"), ":p")
  let _ = copy(s:functions)
  if has_key(s:scriptnames, fname)
    let sid = s:scriptnames[fname]
    call map(_, 'substitute(v:val, "<SNR>".sid."_", "s:", "")')
  endif
  call filter(_, 'stridx(v:val, "<SNR>") == -1')

  return map(_, '{"word": v:val, "abbr": v:val . "()", "kind": "function"}')
endfunction


function! s:functions()
  redir => functions
  silent function
  redir END
  return map(split(functions, '\n'),
        \ 'matchstr(v:val, "function\\s\\zs.\\+\\ze(")')
endfunction


function! s:scriptnames()
  redir => scriptnames
  silent scriptnames
  redir END
  let _ = {}
  for scr in map(split(scriptnames, '\n'), 'split(v:val, ": ")')
    call extend(_, {fnamemodify(scr[1], ":p") : eval(scr[0])})
  endfor
  return _
endfunction


call yavimomni#user_function#init()
