ya-vimomni.vim
==============

Yet another vim omni-completion plugin.

Configuration
-------------

Trigger completion on typing `#` in addition to '.' when using with [YouCompleteMe](https://github.com/Valloric/YouCompleteMe).

    " Add semantic triggers
    let g:ycm_semantic_triggers = {'vim' : ['.', '#']}
