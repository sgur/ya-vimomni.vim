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
  echomsg 'Options' len(s:options)
endfunction


function! yavimomni#option#get(arglead)
  return yavimomni#util#convert_list_candidates(
      \ filter(copy(s:options), 'stridx(v:val, a:arglead) >= 0'))
endfunction
