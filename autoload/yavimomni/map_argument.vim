" map-arguments

function! yavimomni#map_argument#init()
  let s:mapargments = map(['<buffer>', '<silent>', '<special>', '<script>', '<expr>', '<unique>'],
        \ '{"word": v:val, "menu": "[map-argument]"}')
endfunction

function! yavimomni#map_argument#get(arglead)
  return copy(s:mapargments)
endfunction


" Initialization

call yavimomni#map_argument#init()
