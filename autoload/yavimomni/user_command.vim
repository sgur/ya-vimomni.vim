" User commands

function! yavimomni#user_command#init()
endfunction


function! yavimomni#user_command#get(arglead)
  if !exists('b:user_commands')
    let b:user_commands = s:init()
  endif
  return filter(copy(b:user_commands), 'stridx(v:val, a:arglead) >= 0')
endfunction


function! s:init()
  redir => commands
  silent command
  redir END
  return map(split(commands, '\r\n\|\n\|\r')[1:],'matchstr(v:val, "\\i\\+\\ze\\s", 3)')
endfunction
