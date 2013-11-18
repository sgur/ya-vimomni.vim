"=============================================================================
" FILE: cache.vim
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


" Interface

" function! yavimomni#cache#exists(kind, orig_filename)
function! yavimomni#cache#exists(kind, ...)
  let cache = s:cache_filename(a:kind)
  if !filereadable(cache)
    return 0
  endif
  if a:0 > 0
    return filereadable(a:1) && getftime(s:cache_filename(a:kind)) > getftime(a:1)
  else
    return localtime() - getftime(s:cache_filename(a:kind)) < s:expire_seconds
  else
endfunction

function! yavimomni#cache#store(kind, candidates)
  echomsg 'Create cache' a:kind
  call writefile([string(a:candidates)], s:cache_filename(a:kind))
endfunction

function! yavimomni#cache#load(kind)
  let lines = readfile(s:cache_filename(a:kind))
  return len(lines) > 0 ? eval(lines[0]) : []
endfunction

function! s:cache_filename(kind)
  return expand(s:cache_directory . '/' . a:kind . '.vimson')
endfunction

" Internal

let s:expire_seconds = 60 * 60 * 24 * 7 " 1week

let s:cache_directory = expand('~/.cache/yavimomni')

" Initialization

if !isdirectory(s:cache_directory)
  call mkdir(s:cache_directory, 'p')
endif


let &cpo = s:save_cpo
unlet s:save_cpo

