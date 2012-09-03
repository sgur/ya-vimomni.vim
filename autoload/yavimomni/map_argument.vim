" map-arguments

function! yavimomni#map_argument#init()
  let s:mapargments = ['<buffer>', '<silent>', '<special>', '<script>', '<expr>', '<unique>']
  echo "Map arguments" len(s:mapargments)
endfunction

function! yavimomni#map_argument#get(arglead)
  return s:mapargments
endfunction
