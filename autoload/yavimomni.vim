"=============================================================================
" FILE: autoload/yavimomni.vim
" AUTHOR: sgur <sgurrr+vim@gmail.com>
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim


function! yavimomni#complete(findstart, base)
  let isk = &isk
  set isk+=#,:
  try
    if a:findstart " 1st time
      let start = col('.') - 1
      let line = getline('.')
      while start > 0 && line[start-1] =~ '\%(\k\|[<>]\)'
        let start -= 1
      endwhile
      return start
    else " 2nd time
      let context = s:concat_lines('.')
      if context =~ '^\s*"'
        return [] "Comment
      endif
      if context =~ '\(\%(\k\+\.\)*\k\+\)\.\k*$'
        return s:get_candidates_of_member(context)
      endif
      if context =~ '\(\%(\k\+\.\)*\k\+\%(\[\k\+\]\)*\)\[\k*'
        return s:get_candidates_of_bracket(context)
      endif
      return s:get_candidates_by_context(context, a:base)
    endif
  finally
    let &isk = isk
  endtry
endfunction


function! yavimomni#candidates(base)
  let context = s:concat_lines('.')
  return s:get_candidates_by_context(context, a:base)
endfunction


function! s:concat_lines(pos)
  let lnum = line(a:pos)
  let line = getline(lnum)
  while line =~ '^\s*\\' && lnum > 1
    let lnum -= 1
    let line = getline(lnum) . substitute(line, '^\s*\\', '', '')
  endwhile
  return line =~ '^\s*$' ? '' : split(line, '\%(\S\?\zs\s*|\|<bar>\)\s*')[-1]
endfunction


function! s:get_candidates_by_context(line, arglead)
  let _ = []
  if a:line =~# '\.$'
    return _
  endif
  let line = a:line[ : col('.')-2] . a:arglead . a:line[col('.')-1 : ]
  let term = matchstr(line, '[[:alnum:]<>]\+$')
  for kind in s:enable_module_from_pattern(line)
    call extend(_, yavimomni#{kind}#get(term))
  endfor
  call filter(_, 'stridx(v:val["word"], term) == 0')
  if a:arglead != term
    for cand in _
      let cand["word"] = substitute(cand["word"], term, '', '')
      let cand["abbr"] = cand["word"]
    endfor
  endif
  return sort(_, 1)[:&lines]
endfunction


function! s:get_candidates_of_member(receiver)
  let var = matchstr(a:receiver, '\S\+\ze\.')
  if !exists(var)  " assumed that a:receiver is a variable
    return []
  endif
  let recv = eval(var)
  if type(recv) != type({})
    return []
  endif
  return map(keys(recv), '{"word" : v:val , "menu" : string(eval(var . "[\"" . v:val . "\"]"))}')
endfunction


function! s:get_candidates_of_bracket(receiver)
  let var = matchstr(a:receiver, '\S\+\ze\[')
  if !exists(var)  " assumed that a:receiver is a variable
    return []
  endif
  let recv = eval(var)
  if type(recv) != type({})
    return []
  endif
  return map(keys(recv), '{"word" : "''" . v:val . "''", "menu" : string(eval(var . "[\"" . v:val . "\"]"))}')
endfunction

function! s:enable_module_from_pattern(line)
  let _ = []

  if a:line =~# '&\S*$'
    call add(_, 'option')
  elseif a:line =~# '@\S*$'
    call add(_, 'register')
  elseif a:line =~# '$\S*$'
    call add(_, 'environment')
  elseif a:line =~# '\<has([''"]\%' . col('.') . 'c\k*[''")]*$'
    call add(_, 'feature')
  elseif a:line =~# '\<expand([''"]<\%>' . col('.') . 'c\k*[''")]*$'
    call add(_, 'specials')
  elseif a:line =~# '\<\%(se\%[tlocal]\)\s\+'
    call add(_, 'option')
  elseif a:line =~# '\%(let\|unl\%[et]\)\s*[^=]*$'
        \ ||  a:line =~# 'lockv\%(ar\)'
        \ || a:line =~# 'unlo\%(ckvar\)'
    call extend(_, ['variable', 'script_variable'])
    call extend(_, ['variable', 'script_variable'])
  elseif a:line =~# 'let.\+=\|call\?\|if\|elseif\?\|wh\%[ile]\|for.\+in\|th\%[row]\|ec\%[ho]\|echo\%(n\|hl\?\|m\%[sg]\|e\%[rr]\)\|exe\%[cute]\|retu\%[rn]\|\u\k\+\s'
    call extend(_, ['function', 'user_function', 'variable', 'script_variable'])
  elseif a:line =~# 'for'
    call add(_, 'empty')
  elseif a:line =~ 'colo\%[rscheme]\s\+$'
    call add(_, 'colorscheme')
  elseif a:line =~# '\<\%(' . join([
        \ 's\?map', 'map!', '[nvxoilc]m\%(ap\)\?', 'no\%(remap\)\?',
        \ '\%(nn\|vn\|xn\)\%(oremap\)\?', 'snor\%(emap\)\?',
        \ '\%(ono\|no\|ino\)\%(remap\)\?', 'ln\%(oremap\)\?',
        \ 'cno\%(remap\)\?',
        \ ], '\|') . '\)\>[^:]*$'
    call add(_, 'map_argument')
  else
    call extend(_, ['ex_command', 'user_command'])
  endif

  return _
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
finish
