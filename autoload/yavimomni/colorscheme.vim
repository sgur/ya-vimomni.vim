" Colorscheme

function! yavimomni#colorscheme#init()
  let colorscheme = split(globpath(&runtimepath, 'colors/*.vim'), '\n')
  let s:colorscheme = map(colorscheme
        \ , '{"word" : fnamemodify(v:val, ":t:r"), "menu" : fnamemodify(v:val, ":.")}')
endfunction


function! yavimomni#colorscheme#get(arglead)
  return filter(copy(s:colorscheme), 'stridx(v:val.word, a:arglead) == 0')
endfunction
