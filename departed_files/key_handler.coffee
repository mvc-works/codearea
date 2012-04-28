
o = (v...) -> console.log v
tool = global_sharing_tools

# tab to indent is neccesary
window.key_tab = (area) ->
  now = tool.wrap_text area
  # o now
  if now.same
    lines = now.lines
    row = now.a_row
    if now.a_sta and row > 0 and lines[row-1].match /^\s+/
      spaces = (lines[row-1].match /^\s+/)[0]
      space_n = spaces.length
      lines[row] = spaces + lines[row]
      obj =
        lines: lines
        a_row: row
        a_col: space_n
      tool.write_text area, obj
    else
      spaces = (lines[row].match /^\s*/)[0]
      space_n = spaces.length
      add_n = 2 - space_n%2
      if add_n is 1
        lines[row] = '\ '+lines[row]
      else
        lines[row] = '\ \ '+lines[row]
      obj =
        lines: lines
        a_row: row
        a_col: now.a_col + add_n
      tool.write_text area, obj
  else
    sta_line = now.a_row
    end_line = now.b_row
    lines = now.lines
    for index in [sta_line..end_line]
      lines[index] = '\ \ '+lines[index]
    obj =
      lines: lines
      a_row: sta_line
      a_col: now.a_col
      b_row: end_line
      b_col: now.b_col+2
    tool.write_text area, obj
  false

# use shift tab to remove indentation
window.key_shift_tab = (area) ->
  now = tool.wrap_text area
  lines = now.lines
  if now.same
    row = now.a_row
    spaces = (lines[row].match /^\s*/)[0]
    space_n = spaces.length
    reduce_n = 2 - spaces%2
    o lines[row], spaces, space_n, reduce_n
    if space_n >= reduce_n
      lines[row] = lines[row][reduce_n..]
      obj =
        lines: lines
        a_row: row
        a_col: if now.a_col-reduce_n>0 then now.a_col-reduce_n else 0
      tool.write_text area, obj
  else
    sta_row = now.a_row
    end_row = now.b_row
    space_ns = lines[sta_row..end_row].map (line) ->
      spaces = (line.match /^\s*/)[0]
      spaces.length
    o space_ns
    min_spaces = space_ns.reduce (a, b) -> if a<b then a else b
    o min_spaces
    if min_spaces > 0
      reduce_n = 2 - min_spaces%2
      for index in [sta_row..end_row]
        lines[index] = lines[index][reduce_n..]
      obj =
        lines: lines
        a_row: sta_row
        a_col: now.a_col - reduce_n
        b_row: end_row
        b_col: now.b_col - reduce_n
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

# delete form curse to the start of the line, similar to k..
window.key_ctrl_u = (area) ->
  now = tool.wrap_text area
  if now.same
    lines = now.lines
    row = now.a_row
    col = now.a_col
    lines[row] = lines[row][col..]
    obj =
      lines: lines
      a_row: row
      a_col: 0
    tool.write_text area, obj
    return false

# unfocus the textarea
window.key_esc = (area) ->
  do area.blur

# delete current line
window.key_ctrl_shift_k = (area) ->
  now = tool.wrap_text area
  if now.same
    row = now.a_row
    lines = now.lines
    lines = lines[...row].concat lines[row+1..]
    # o lines
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
    o 'origin lines: ', lines
    lines = lines[...sta_row].concat lines[end_row+1..]
    o 'after; ', lines
    a_row = if sta_row>0 then sta_row-1 else 0
    obj =
      lines: lines
      a_row: a_row
    o obj
    tool.write_text area, obj
  return false

# duplicate current line
window.key_ctrl_shift_d = (area) ->
  now = tool.wrap_text area
  lines = now.lines
  if now.same
    row = now.a_row
    lines = lines[..row].concat lines[row..]
    obj =
      lines: lines
      a_row: row+1
      a_col: now.a_col
    tool.write_text area, obj
  else
    sta_row = now.a_row
    end_row = now.b_row
    lines = lines[..end_row].concat lines[sta_row..]
    duplicate = end_row - sta_row + 1
    obj =
      lines: lines
      a_row: sta_row + duplicate
      a_col: now.a_col
      b_row: end_row + duplicate
      b_col: now.b_col
    tool.write_text area, obj
  return false

# enter only, consider last line and
window.key_enter = (area) ->
  now = tool.wrap_text area
  if now.same
    row = now.a_row
    col = now.a_col
    lines = now.lines
    lines = lines[..row].concat lines[row..]
    lines[row] = lines[row][...col]
    spaces = (lines[row].match /^\s*/)[0]
    space_n = spaces.length
    lines[row+1] = spaces + lines[row+1][col..]
    obj =
      lines: lines
      a_row: row+1
      a_col: space_n
    tool.write_text area, obj
    return false

# press backspace at head, last line if empty, delete it
window.key_backspace = (area) ->
  now = tool.wrap_text area
  if now.same
    row = now.a_row
    lines = now.lines
    if lines[row-1]? and now.a_sta
      if lines[row-1].match /^\s+$/
        lines = lines[...row-1].concat lines[row..]
        obj =
          lines: lines
          a_row: row-1
          a_col: 0
        tool.write_text area, obj
        return false
    # o now.a_end
    if lines[row].length>1 and (not now.a_end)
      pair = lines[row][now.a_col-1..now.a_col]
      # o pair
      if pair in ['{}', '()', '[]', '""', "''", '``']
        lines[row] = lines[row][...now.a_col] + lines[row][now.a_col+1..]
        obj =
          lines: lines
          a_row: now.a_row
          a_col: now.b_col
        tool.write_text area, obj

# ctrl Enter to open a new line with indentation
window.key_ctrl_enter = (area) ->
  now = tool.wrap_text area
  if now.same
    row = now.a_row
    lines = now.lines
    new_line = (lines[row].match /^\s*/)[0]
    lines = lines[0..row].concat([new_line]).concat lines[row+1..]
    obj =
      lines: lines
      a_row: row + 1
    tool.write_text area, obj

# ctrl shift Enter nearly the same, but put at above
window.key_ctrl_shift_enter = (area) ->
  now = tool.wrap_text area
  if now.same
    row = now.a_row
    lines = now.lines
    new_line = (lines[row].match /^\s*/)[0]
    lines = lines[0...row].concat([new_line]).concat lines[row..]
    obj =
      lines: lines
      a_row: row
    tool.write_text area, obj

# move current line up
window.key_ctrl_shift_up = (area) ->
  now = tool.wrap_text area
  if now.same
    row = now.a_row
    if row > 0
      lines = now.lines
      [lines[row], lines[row-1]] = [lines[row-1], lines[row]]
      obj =
        lines: lines
        a_row: row-1
        a_col: now.a_col
      tool.write_text area, obj
  else
    sta_row = now.a_row
    end_row = now.b_row
    if sta_row > 0
      lines = now.lines
      t_line = lines[sta_row-1]
      for line, index in lines[sta_row..end_row]
        lines[sta_row+index-1] = line
      lines[end_row] = t_line
      obj =
        lines: lines
        a_row: sta_row - 1
        a_col: now.a_col
        b_row: end_row - 1
        b_col: now.b_col
      tool.write_text area, obj
  false

# move current line udown
window.key_ctrl_shift_down = (area) ->
  now = tool.wrap_text area
  lines = now.lines
  if now.same
    row = now.a_row
    if row < lines.length - 1
      [lines[row], lines[row+1]] = [lines[row+1], lines[row]]
      obj =
        lines: lines
        a_row: row+1
        a_col: now.a_col
      tool.write_text area, obj
  else
    sta_row = now.a_row
    end_row = now.b_row
    if end_row < lines.length - 1
      t_line = lines[end_row+1]
      for line, index in lines[sta_row..end_row]
        lines[sta_row+index+1] = line
      lines[sta_row] = t_line
      obj =
        lines: lines
        a_row: sta_row + 1
        a_col: now.a_col
        b_row: end_row + 1
        b_col: now.b_col
      tool.write_text area, obj
  false

# go to the begining of whole page
window.key_ctrl_home = (area) ->
  now = tool.wrap_text area
  if now.same
    obj =
      lines: now.lines
      a_row: 0
      a_col: 0
    tool.write_text area, obj

# go to the end of whole page
window.key_ctrl_end = (area) ->
  now = tool.wrap_text area
  if now.same
    lines = now.lines
    obj =
      lines: lines
      a_row: lines.length - 1
    tool.write_text area, obj

# left-bracket
window.key_bracket = (area, bracket) ->
  now = tool.wrap_text area
  lines = now.lines
  a_row = now.a_row
  a_col = now.a_col
  b_row = now.b_row
  b_col = now.b_col
  # o bracket
  lines[b_row] = lines[b_row][...b_col] + bracket[1] + lines[b_row][b_col..]
  lines[a_row] = lines[a_row][...a_col] + bracket[0] + lines[a_row][a_col..]
  # o lines[0]
  obj =
    lines: lines
    a_row: a_row
    a_col: a_col + 1
    b_row: b_row
    b_col: b_col + 1
  tool.write_text area, obj
  return false

window.key_bracket_close = (area, closer) ->
  now = tool.wrap_text area
  if now.same
    row = now.a_row
    col = now.a_col
    lines = now.lines
    target = lines[row][col]
    if target? and target is closer
      obj =
        lines: lines
        a_row: row
        a_col: col + 1
      tool.write_text area, obj
      return false