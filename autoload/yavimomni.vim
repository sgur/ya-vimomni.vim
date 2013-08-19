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


" The Other
call yavimomni#ex_command#init()
call yavimomni#user_command#init()
" Just after :lockvar, :unlockvar, :let :unlet
" After :if, :while :for
call yavimomni#variable#init()
call yavimomni#script_variable#init()
" After :call, :return, :let {var}=
" Parameters
call yavimomni#function#init()
call yavimomni#user_function#init()
" After :set, :let &{var}=
call yavimomni#option#init()
" After :map
call yavimomni#map_argument#init()
" has()
call yavimomni#feature#init()
" colorscheme
call yavimomni#colorscheme#init()


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
      let sentence = s:concat_lines('.', '.')
      let matches_member = matchlist(sentence,  '\(\%(\k\+\.\)*\k\+\)\.\k*$')
      let matches_bracket = matchlist(sentence, '\(\%(\k\+\.\)*\k\+\%(\[\k\+\]\)*\)\[\k*\]\?$')
      if !empty(matches_member) " member completion
        return s:get_candidates_of_member(matches_member[1], a:base)
      elseif !empty(matches_bracket) "bracket completion
        return s:get_candidates_of_bracket(matches_bracket[1], a:base)
      else " word completion
        return s:get_candidates_by_context(sentence, a:base)
      endif
    endif
  finally
    let &isk = isk
  endtry
endfunction


function! yavimomni#candidates(base)
  let sentence = s:concat_lines('.', '.')
  return s:get_candidates_by_context(sentence, a:base)
endfunction


function! s:concat_lines(line, col)
  let lnum = (type(a:line) == type(0)) ? a:line : line(a:line)
  let col  = (type(a:col) == type(0))  ? a:col  : col(a:col)
  let line = getline(lnum)[:col]
  let match = matchstr(line, '^\s*\\\zs.\+$')
  while match != '' && lnum > 1
    let lnum -= 1
    let line = getline(lnum) . match
    let match = matchstr(line, '^\s*\\\zs.\+$')
  endwhile
  return line
endfunction


function! s:get_candidates_by_context(line, arglead)
  let _ = []
  if a:line !~ '\i\+'
    return _
  endif
  for c in s:enable_module_from_pattern(a:line)
    call extend(_, yavimomni#{c}#get(a:arglead))
  endfor
  return _
endfunction


function! s:get_candidates_of_member(receiver, arglead)
  if !exists(a:receiver)
    return []
  endif
  let recv = eval(a:receiver)
  if type(recv) != type({})
    return []
  endif
  return map(keys(recv), '{"word" : v:val , "menu" : string(eval(a:receiver . "[\"" . v:val . "\"]"))}')
endfunction


function! s:get_candidates_of_bracket(receiver, arglead)
  if !exists(a:receiver)
    return []
  endif
  let recv = eval(a:receiver)
  if type(recv) != type({})
    return []
  endif
  return map(keys(recv), '{"word" : "''" . v:val . "'']", "menu" : string(eval(a:receiver . "[\"" . v:val . "\"]"))}')
endfunction


function! s:enable_module_from_pattern(line)
  let _ = []

  if a:line =~ 'colo\%[rscheme]\s\+$'
    call add(_, 'colorscheme')
    return _
  endif

  if a:line =~ "has(['\"]"
    call add(_, 'feature')
    return _
  endif

  if a:line =~ '\<\%(se\%[tlocal]\s\+\|let\s\+&\%(\.:\)\?\)'
    call add(_, 'option')
    return _
  endif

  if a:line =~ '\<\%(' . join([
        \ 's\?map', 'map!', '[nvxoilc]m\%(ap\)\?', 'no\%(remap\)\?',
        \ '\%(nn\|vn\|xn\)\%(oremap\)\?', 'snor\%(emap\)\?',
        \ '\%(ono\|no\|ino\)\%(remap\)\?', 'ln\%(oremap\)\?',
        \ 'cno\%(remap\)\?',
        \ ], '\|') . '\)\>'
    call add(_, 'map_argument')
  endif

  if a:line !~ '^\s*$'
    call add(_, 'function')
  endif

  call extend(_, ['ex_command', 'user_command'])
  call extend(_, ['script_variable', 'variable'])
  call extend(_, ['function', 'user_function'])

  return _
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
