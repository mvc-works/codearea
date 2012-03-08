
o = (v...) -> console.log v

window.key_tab = (area, tool) ->
  now = tool.wrap_text area
  # o now
  obj = {}
  if now.same
    # o now.a_sta, now.a_end, now.a_row, now.tail
    if now.a_sta and now.a_end
      now.lines[now.a_row] += '  '
      tool.write_text area, now.lines, 0, 0
    return false
  else
    o 'selection'
    false

window.key_ctrl_l = (area, tool) ->
  now = tool.wrap_text area
  a_row = now.a_row
  a_col = 0
  if now.lines[a_row-1]?
    a_row -= 1
    a_col = null
  obj =
    lines: now.lines
    a_row: a_row
    a_col: a_col
    b_row: now.b_row
  o obj, now
  tool.write_text area, obj
  return false

# enter only, consider last line and 