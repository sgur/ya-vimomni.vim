" feature

function! yavimomni#feature#init()
  let helpfile = expand(findfile('doc/eval.txt', &runtimepath))
  if yavimomni#cache#exists('feature', helpfile)
    let s:features = yavimomni#cache#load('feature')
  else
    if filereadable(helpfile)
      let lines = readfile(helpfile)
      let start = match(lines, '^all_builtin_terms')
      let end = match(lines, '^x11')
      let features = []
      for l in lines[start : end]
        let _ = matchlist(l, '^\(\k\+\)\t\+\(.\+\)$')
        if !empty(_)
          call add(features, {
                \ 'word' : _[1],
                \ 'menu' : _[2],
                \ })
          " \ 'info' : _[2],
        endif
      endfor
      let s:features = features
      call yavimomni#cache#store('feature', features)
    else
      echoerr 'yavimomni: vim help file not readable.'
    endif
  endif
endfunction


function! yavimomni#feature#get(arglead)
  return filter(copy(s:features), 'stridx(v:val.word, a:arglead) == 0')
endfunction
