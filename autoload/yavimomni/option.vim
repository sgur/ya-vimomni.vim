" Options

function! yavimomni#option#init()
  redir => raw
  silent set all
  redir END
  let options = map(filter(map(
        \ split(raw, '\s\{2,}\|\n')[1:],
        \ 'split(v:val, "=", 1)[0]'),
        \ '!empty(v:val)'),
        \ 'substitute(v:val, "^no", "", "")')
  let s:options = options + map(copy(options), 'substitute(v:val, "^", "no", "")')
endfunction


function! yavimomni#option#get()
  return s:options
endfunction
