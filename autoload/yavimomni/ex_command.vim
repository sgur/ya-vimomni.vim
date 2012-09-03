" Ex-commands

function! yavimomni#ex_command#init()
  let helpfile = expand(findfile('doc/index.txt', &runtimepath))
  if filereadable(helpfile)
    let lines = readfile(helpfile)
    let exs = []
    for l in lines
      let _ = matchlist(l, '^|:\(.\+\)|.\+\t\(.\+\)$')
      if !empty(_)
        call add(exs, {
              \ 'word' : _[1],
              \ 'menu' : _[2],
              \ })
        " \ 'info' : _[2],
      endif
    endfor
    let s:ex_commands = exs
  endif
  echomsg 'Ex commands' len(s:ex_commands)
endfunction


function! yavimomni#ex_command#get(arglead)
  return filter(copy(s:ex_commands), 'stridx(v:val.word, a:arglead) >= 0')
endfunction
