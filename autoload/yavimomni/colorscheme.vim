" Colorscheme

function! yavimomni#colorscheme#get(arglead)
  return copy(s:colorscheme)
endfunction


" Initialization

let s:colorscheme = map(split(globpath(&runtimepath, 'colors/*.vim'), '\n')
      \ , '{"word": fnamemodify(v:val, ":t:r"), "kind": "color", "menu": yavimomni#util#truncate(fnamemodify(v:val, ":."), yavimomni#util#truncate_length())}')

