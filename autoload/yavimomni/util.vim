function! yavimomni#util#convert_list_candidates(list)
  return map(a:list, "{
      \ 'word' : v:val,
      \ 'menu' : v:val,
      \ }" )
endfunction

