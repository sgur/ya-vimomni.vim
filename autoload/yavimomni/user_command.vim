" User commands

function! yavimomni#user_command#init()
endfunction


function! yavimomni#user_command#get(arglead)
  if !exists('b:user_commands')
    let b:user_commands = s:init()
  endif

  return copy(b:user_commands)
endfunction


function! s:init()
  redir => commands
  silent command
  redir END
  return map(split(commands, '\r\n\|\n\|\r')[1:],
        \ '{"word": matchstr(v:val, "\\i\\+\\ze\\s", 3), "menu": "[C]"}')
endfunction


" Initialization

call yavimomni#user_command#init()
