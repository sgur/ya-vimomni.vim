" map-arguments

function! yavimomni#specials#init()
  let s:mapargments = map(['<cfile>', '<afile>', '<abuf>', '<amatch>', '<sfile>', '<cword>', '<cWORD>', '<client>'],
        \ '{"word": v:val, "kind": "special"}')
endfunction

function! yavimomni#specials#get(arglead)
  return copy(s:mapargments)
endfunction


" Initialization

call yavimomni#specials#init()
