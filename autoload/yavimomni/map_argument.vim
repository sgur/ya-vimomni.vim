" map-arguments

function! yavimomni#map_argument#init()
  let s:mapargments = ['<buffer>', '<silent>', '<special>', '<script>', '<expr>', '<unique>']
endfunction

function! yavimomni#map_argument#get(arglead)
  return s:mapargments
endfunction


" Initialization

call yavimomni#map_argument#init()
