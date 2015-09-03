let s:save_cpo = &cpo
set cpo&vim

" Registers

function! yavimomni#register#init()
  let nums = map(range(0, 9), 'string(v:val)')
  let lowers = map(range(char2nr('a'), char2nr('a') + 25), 'nr2char(v:val)')
  let uppers = map(range(char2nr('A'), char2nr('A') + 25), 'nr2char(v:val)')
  let s:registers = map(['"', '-', ':', '.', '%', '#', '*', '+', '~', '/']
        \ + nums + lowers + uppers,
        \ '{"word": v:val, "kind": "register", "menu": yavimomni#util#truncate(getreg(v:val), yavimomni#util#truncate_length())}')
endfunction

function! yavimomni#register#get(arglead)
  return copy(s:registers)
endfunction


" Initialization

call yavimomni#register#init()

let &cpo = s:save_cpo
unlet s:save_cpo
