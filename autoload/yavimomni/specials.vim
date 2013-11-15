" map-arguments

function! yavimomni#specials#init()
  let s:mapargments = ['<cfile>', '<afile>', '<abuf>', '<amatch>', '<sfile>', '<cword>', '<cWORD>', '<client>']
endfunction

function! yavimomni#specials#get(arglead)
  return s:mapargments
endfunction
