" Built-in functions

function! s:init()
  let helpfile = expand(findfile('doc/eval.txt', &runtimepath))
  if yavimomni#cache#exists('function', helpfile)
    let s:builtin_functions = yavimomni#cache#load('function')
  else
    if filereadable(helpfile)
      let lines = readfile(helpfile)
      let functions = []
      let start = match(lines, '^abs')
      let end = match(lines, '^abs', start, 2)
      let desc = ''
      for i in range(end-1, start, -1)
        let desc = substitute(lines[i], '^\s\+\ze\S', '', '').' '.desc
        let _ = matchlist(desc, '^\s*\(\(\i\+\)(.\+)\)\s\+\(\w\+\)\s\+\(.\+[^*]\)$')
        if !empty(_)
          call insert(functions, {
                \ 'word' : _[2],
                \ 'abbr' : _[2] . '()',
                \ 'kind' : 'function',
                \ 'menu' : yavimomni#util#truncate(_[1] . ' ' . _[4], yavimomni#util#truncate_length())
                \ })
          let desc = ''
        endif
      endfor
      let s:builtin_functions = functions
      call yavimomni#cache#store('function', functions)
    else
      echoerr 'yavimomni: vim help file not readable.'
    endif
  endif
endfunction


function! yavimomni#function#get(arglead)
  return copy(s:builtin_functions)
endfunction


" Initialization

call s:init()
