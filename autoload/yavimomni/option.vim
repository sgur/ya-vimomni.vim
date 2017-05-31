scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

" Options

function! yavimomni#option#get(arglead)
  let prefix = matchstr(a:arglead, '^[gl]:')
  let opt={}
  execute "silent normal! :let &" . a:arglead . "\<c-a>\<c-\>eextend(opt, {'candidates':getcmdline()}).candidates\n"
  return map(filter(has_key(opt, 'candidates') && opt['candidates'] !~ ''
        \ ? split(opt['candidates'][stridx(opt['candidates'], '&' . prefix)+1 :],'\\\@<!\s\+') : []
        \ , 'exists("&" . v:val)'), '
        \ { "word": prefix . v:val
        \ , "kind": "option"
        \ , "menu": yavimomni#util#truncate(eval("&" . prefix . v:val), yavimomni#util#truncate_length())}
        \ ')
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
