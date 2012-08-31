" Built-in functions

function! yavimomni#function#init()
  let helpfile = expand('$VIMRUNTIME/doc/eval.txt')
  if filereadable(helpfile)
    let lines = readfile(helpfile)
    let functions = []
    let start = match(lines, '^USAGE')
    let end = match(lines, '^abs', start, 2)
    for l in lines[start : end]
      let _ = matchlist(l, '^\(\i\+(\).\+\t\(.\+[^*]\)$')
      if !empty(_)
        call add(functions, {
              \ 'word' : _[1],
              \ 'menu' : _[2],
              \ })
        " \ 'info' : _[2],
      endif
    endfor
  endif
  let s:builtin_functions = functions
endfunction


function! yavimomni#function#get()
  return s:builtin_functions
endfunction
