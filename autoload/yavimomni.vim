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
      while start > 0 && line[start-1] =~ '\k\|[<>]'
        let start -= 1
      endwhile
      return start
    else " 2nd time
      let context = s:concat_lines('.')
      " let &titlestring = '[DEBUG]context:(' . context . ') base:(' . a:base . ')'
      if context =~ '^\s*"'
        return [] "Comment
      endif
      if context =~ '\(\%(\k\+\.\)*\k\+\)\.\k*$'
        return s:get_candidates_of_member(context, a:base)
      endif
      if context =~ '\(\%(\k\+\.\)*\k\+\%(\[\k\+\]\)*\)\[\k*'
        return s:get_candidates_of_bracket(context, a:base)
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
  let col = col(a:pos)

  let line = getline(lnum)
  while line =~ '^\s*\\' && lnum > 0
    let line = getline(lnum) . substitute(line, '^\s*\\', '', '')
    let lnum -= 1
  endwhile
  return line =~ '^\s*$' ? '' : split(line, '\%(\S\?\zs\s*|\|<bar>\)\s*')[-1]
endfunction


function! s:get_candidates_by_context(line, arglead)
  let _ = []
  if a:line =~# '\.$'
    return _
  endif
  for c in s:enable_module_from_pattern(a:line)
    call extend(_, yavimomni#{c}#get(a:arglead))
  endfor
  return _
endfunction


function! s:get_candidates_of_member(receiver, arglead)
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


function! s:get_candidates_of_bracket(receiver, arglead)
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

  if a:line =~ 'colo\%[rscheme]\s\+$'
    call add(_, 'colorscheme')
    return _
  endif

  if a:line =~# '\<has([''"]\w*\%([''"])\)\?$'
    call add(_, 'feature')
    return _
  endif

  if a:line =~# '\<\%(se\%[tlocal]\s\+\|let\s\+&\)'
    call add(_, 'option')
    return _
  endif

  if a:line =~# '\<expand([''"][<>[:alnum:]]*\%([''"])\)\?$'
    call add(_, 'specials')
    return _
  endif

  if a:line =~# '\<\%(' . join([
        \ 's\?map', 'map!', '[nvxoilc]m\%(ap\)\?', 'no\%(remap\)\?',
        \ '\%(nn\|vn\|xn\)\%(oremap\)\?', 'snor\%(emap\)\?',
        \ '\%(ono\|no\|ino\)\%(remap\)\?', 'ln\%(oremap\)\?',
        \ 'cno\%(remap\)\?',
        \ ], '\|') . '\)\>[^:]*$'
    call add(_, 'map_argument')
  endif

  if a:line =~# 'let\s\+[^=]*$'
    call extend(_, ['variable', 'script_variable'])
  endif

  if a:line =~# 'let.\+=\|call\|if\|elseif\?\|wh\%[ile]\|for\|th\%[row]\|ec\%[ho]\|echo\%(n\|hl\?\|m\%[sg]\|e\%[rr]\)\|exe\%[cute]'
    call extend(_, ['function', 'user_function'])
    call extend(_, ['variable', 'script_variable'])
  else
    call extend(_, ['ex_command', 'user_command'])
  endif

  return _
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
