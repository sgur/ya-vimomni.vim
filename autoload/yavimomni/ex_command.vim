" Ex-commands

function! s:init()
  let helpfile = expand(findfile('doc/index.txt', &runtimepath))
  if yavimomni#cache#exists('ex_command', helpfile)
    let s:ex_commands = yavimomni#cache#load('ex_command')
  else
    if filereadable(helpfile)
      let lines = readfile(helpfile)
      let exs = []
      let start = match(lines, '^|:!|')
      let end = match(lines, '^|:\~|', start)
      let desc = ''
      for lnum in range(end, start, -1)
        let desc = substitute(lines[lnum], '^\s\+\ze', '', 'g') . ' ' . desc
        let _ = matchlist(desc, '^|:\(.\{-}\)|\s\+\S\+\s\+\(.\+\)$')
        if !empty(_)
          call add(exs, {
                \ 'word' : _[1],
                \ 'kind' : 'command',
                \ 'menu' : yavimomni#util#truncate(_[2], yavimomni#util#truncate_length())
                \ })
          " \ 'info' : _[1] . "\n" . _[2]
          let desc = ''
        endif
      endfor
      let s:ex_commands = exs
      call yavimomni#cache#store('ex_command', exs)
    else
      echoerr 'yavimomni: vim help file not readable.'
    endif
  endif
endfunction


function! yavimomni#ex_command#get(arglead)
  return copy(s:ex_commands)
endfunction


" Initialization

call s:init()
