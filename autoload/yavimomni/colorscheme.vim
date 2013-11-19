" Colorscheme

function! yavimomni#colorscheme#init()
  let colorscheme = split(globpath(&runtimepath, 'colors/*.vim'), '\n')
  let s:colorscheme = map(colorscheme
        \ , '{"word": fnamemodify(v:val, ":t:r"), "menu": "[colorscheme]", "info": fnamemodify(v:val, ":.")}')
endfunction


function! yavimomni#colorscheme#get(arglead)
  return copy(s:colorscheme)
endfunction


" Initialization

call yavimomni#colorscheme#init()
