function! yavimomni#util#convert_list_candidates(list)
  return map(a:list, "{
      \ 'word' : v:val,
      \ 'menu' : v:val,
      \ }" )
endfunction


function! yavimomni#util#truncate(string, length)
  return join(split(a:string, '\zs')[: a:length-1], '')
endfunction


function! yavimomni#util#truncate_length()
  return 40
endfunction
