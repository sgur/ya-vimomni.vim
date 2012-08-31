" Built-in functions

function! yavimomni#function#init()
  let helpfile = expand('$VIMRUNTIME/doc/eval.txt')
  if filereadable(helpfile)
    let lines = readfile(helpfile)
    let functions = []
    let start = match(lines, '^abs')
    let end = match(lines, '^abs', start, 2)
    let desc = ''
    for i in range(end-1, start, -1)
      let desc = substitute(lines[i], '^\s\+\ze\S', '', '').' '.desc
      let _ = matchlist(desc, '^\s*\(\i\+(\).\+\t\(.\+[^*]\)$')
      if !empty(_)
        call insert(functions, {
              \ 'word' : _[1],
              \ 'menu' : _[2],
              \ })
        " \ 'info' : _[2],
        let desc = ''
      endif
    endfor
    let s:builtin_functions = functions
  else
    echoerr 'yavimomni: vim help file not readable.'
  endif
endfunction


function! yavimomni#function#get()
  return s:builtin_functions
endfunction
