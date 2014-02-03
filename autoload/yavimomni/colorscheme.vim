" Colorscheme

function! yavimomni#colorscheme#init()
  let colorscheme = split(globpath(&runtimepath, 'colors/*.vim'), '\n')
  let s:colorscheme = map(colorscheme
        \ , '{"word": fnamemodify(v:val, ":t:r"), "kind": "color", "menu": yavimomni#util#truncate(fnamemodify(v:val, ":."), yavimomni#util#truncate_length())}')
endfunction


function! yavimomni#colorscheme#get(arglead)
  return copy(s:colorscheme)
endfunction


" Initialization

call yavimomni#colorscheme#init()
