" map-arguments

function! yavimomni#map_argument#get(arglead)
  return copy(s:mapargments)
endfunction


" Initialization

let s:mapargments = map(['<buffer>', '<silent>', '<special>', '<script>', '<expr>', '<unique>'],
      \ '{"word": v:val, "kind": "map"}')
