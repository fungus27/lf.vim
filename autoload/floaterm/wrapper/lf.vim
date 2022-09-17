function! floaterm#wrapper#lf#(cmd, jobopts, ...) abort
  let lf_tmpfile = tempname()
  let lastdir_tmpfile = tempname()
  let original_dir = getcwd()
  if &buftype !=# "terminal"
    lcd %:p:h
  endif

  let cmdlist = split(a:cmd)

  if exists('g:lf_command_override')
    let s:lf_command = g:lf_command_override
  else
    let s:lf_command = 'lf'
  endif

  let cmd = s:lf_command . ' ' . '-last-dir-path="' . lastdir_tmpfile . '" -selection-path="' . lf_tmpfile . '"'
  if len(cmdlist) > 1
    let cmd .= ' ' . join(cmdlist[1:], ' ')
  else
    let cmd .= ' "' . getcwd() . '"'
  endif

  exe "lcd " . original_dir
  let cmd = [&shell, &shellcmdflag, cmd]
  let a:jobopts.on_exit = funcref('LfCallback', [lf_tmpfile, lastdir_tmpfile])
  return [v:false, cmd]
endfunction
