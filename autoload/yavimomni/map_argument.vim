" map-arguments

function! yavimomni#map_argument#init()
  let s:mapargments = [ '<buffer>', '<silent>', '<special>', '<script>', '<expr>', '<unique>' ]
endfunction

function! yavimomni#map_argument#get()
  return s:mapargments
endfunction

