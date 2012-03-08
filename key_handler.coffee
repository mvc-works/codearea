
o = (v...) -> console.log v
tool = global_sharing_tools

window.key_tab = (area) ->
  now = tool.wrap_text area
  # o now
  if now.same
    # o now.a_sta, now.a_end, now.a_row, now.tail
    lines = now.lines
    sta = now.a_sta
    end = now.a_end
    row = now.a_row
    col = now.a_col
  else
    sta_line = now.a_row
    end_line = now.b_row
    lines = now.lines
    for index in [sta_line..end_line]
      lines[index] = '  '+lines[index]
    obj =
      lines: lines
      a_row: sta_line
      a_col: now.a_col+2
      b_row: end_line
      b_col: now.b_col+2
    tool.write_text area, obj
  false

# select current line (to the end of last line)
window.key_ctrl_l = (area) ->
  now = tool.wrap_text area
  a_row = now.a_row
  a_col = 0
  if now.lines[a_row-1]?
    a_row -= 1
    a_col = undefined
  obj =
    lines: now.lines
    a_row: a_row
    a_col: a_col
    b_row: now.b_row
  tool.write_text area, obj
  return false

# delete form curse to the end of the line
window.key_ctrl_k = (area) ->
  now = tool.wrap_text area
  if now.same
    lines = now.lines
    row = now.a_row
    col = now.a_col
    lines[row] = lines[row][0...col]
    obj =
      lines: lines
      a_row: row
      a_col: col
    tool.write_text area, obj
    return false

# unfocus the textarea
window.key_esc = (area) ->
  do area.blur

# delete current line
window.key_ctrl_shift_K = (area) ->
  now = tool.wrap_text area
  o 'called'
  if now.same
    row = now.a_row
    lines = now.lines
    lines = lines[...row].concat lines[row+1..]
    o lines
    a_row = row
    a_col = 0
    if row isnt 0
      a_row = row - 1
      a_col = undefined
    obj =
      lines: lines
      a_row: a_row
      a_col: a_col
    tool.write_text area, obj
  else
    sta_row = now.a_row
    end_row = now.b_row
    lines = now.lines
    lines = lines[...sta_row].concat lines[end_row+1..]
    a_row = sta_row - 1
    obj =
      lines: lines
      a_row: a_row
    o obj
    tool.write_text area, obj
  return false

# enter only, consider last line and
window.key_enter = (area) ->
  o ''