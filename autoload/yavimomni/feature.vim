" feature

function! yavimomni#feature#init()
  let helpfile = expand('$VIMRUNTIME/doc/various.txt')
  if filereadable(helpfile)
    let lines = readfile(helpfile)
    let features = []
    for l in lines
      let _ = matchlist(l, '\*+\(\k\+\)\*\t\+\(.\+\)$')
      if !empty(_)
        call add(features, {
              \ 'word' : _[1],
              \ 'menu' : _[2],
              \ })
        " \ 'info' : _[2],
      endif
    endfor
    let s:features = features
  endif
endfunction


function! yavimomni#feature#get()
  return s:features
endfunction
