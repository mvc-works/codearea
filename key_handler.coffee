
o = (v...) -> console.log v

window.key_tab = (area, tool) ->
  now = tool.wrap_text area
  # o now
  if now.same
    # o now.a_sta, now.a_end, now.a_row, now.tail
    if now.a_sta and now.a_end and now.a_row is now.tail
      now.lines[now.a_row] += '  '
      tool.write_text area, now.lines, 0, 0
    return false
  else
    o 'selection'
    false

window.key_ctrl_l = (area, tool) ->
  console.log tool
  return false