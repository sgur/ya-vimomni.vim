let s:save_cpo = &cpo
set cpo&vim

" Environment

function! yavimomni#environment#get(arglead)
  let env={}
  " TODO: same methods for command
  execute "silent normal! :let $" . a:arglead . "\<c-a>\<c-\>eextend(env, {'candidates':getcmdline()}).candidates\n"
  return map(has_key(env, 'candidates') && env['candidates'] !~ ''
        \ ? split(env['candidates'][stridx(env['candidates'], '$')+1 :],'\\\@<!\s\+') : []
        \ , '{"word": v:val, "kind": "environment", "menu": expand("$" . v:val)}')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
