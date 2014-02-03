"=============================================================================
" FILE: autoload/yavimomni/option.vim
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

" Options

function! yavimomni#option#init()
  if yavimomni#cache#exists('option')
    let s:options = yavimomni#cache#load('option')
  else
    redir => raw
    silent set all
    redir END
    let options = filter(map(map(
          \ split(raw, '\s\{2,}\|\n')[1:],
          \ 'substitute(v:val, "\\s*=.*$", "", "")'),
          \ 'substitute(v:val, "^no", "", "")'),
          \ '!empty(v:val) && exists("&".v:val)')
    let s:options = options
    call yavimomni#cache#store('option', options)
  endif
endfunction

function! yavimomni#option#get(arglead)
  let prefix = matchstr(a:arglead, '^[gl]:')
  let arglead = substitute(a:arglead, prefix, '', '')
  return map(copy(s:options), '
        \ { "word": prefix . v:val
        \ , "kind": "option"
        \ , "menu": yavimomni#util#truncate(eval("&".prefix . v:val), yavimomni#util#truncate_length())
        \ }')
endfunction


" Initialization

call yavimomni#option#init()

let &cpo = s:save_cpo
unlet s:save_cpo
