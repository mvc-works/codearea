
textareaEditor = (textarea_id) ->
  # take id and find the element
  tag = (tagid) -> document.getElementById tagid
  area = tag textarea_id

  # output function o
  o = (v...) -> console.log v

  # main idea, to wrap text to lines in object
  wrap_text = (area) ->
    sta = area.selectionStart
    end = area.selectionEnd
    contx = area.value
    lines = contx.split '\n'
    obj =
      lines: lines
      a_row: get_row     contx, sta
      a_col: get_col     contx, sta
      a_sta: at_line_sta contx, sta
      a_end: at_line_end contx, sta
      b_row: get_row     contx, end
      b_col: get_col     contx, end
      b_sta: at_line_sta contx, end
      b_end: at_line_end contx, end
      same:  sta is end

  # have args about text, implement it
  write_text = (area, obj) ->
    arr = if obj.lines.length > 0 then obj.lines else ['']
    # o obj
    end_line = arr.length - 1
    a_row = if obj.a_row? then obj.a_row else end_line
    a_col = if obj.a_col? then obj.a_col else arr[a_row].length
    b_row = if obj.b_row? then obj.b_row else a_row
    if obj.b_col? then b_col = obj.b_col
    else
      if obj.b_row? then b_col = arr[b_row].length
      else b_col = a_col
    # o '4: ', a_row, a_col, b_row, b_col, obj.b_col
    area.value = arr.join '\n'
    area.selectionStart = set_position arr, a_row, a_col
    area.selectionEnd = set_position arr, b_row, b_col

  # change raw and column index to position
  set_position = (arr, row, col) ->
    lines_before_curse = arr[0...row]
    inline_before_curse = if arr[row]? then arr[row][0...col] else ''
    lines_before_curse.push inline_before_curse
    text_before_curse = lines_before_curse.join '\n'
    position = text_before_curse.length

  # function to get the row index
  get_row = (str, point) ->
    count = 0
    str = str[...point]
    count += 1 for i in str when i is '\n'
    count

  # function to get column index
  get_col = (str, point) ->
    str = str[0...point]
    last = str.lastIndexOf '\n'
    last += 1
    sub_str = str[last..]
    n = sub_str.length

  # line start or not
  at_line_sta = (text, point) ->
    p = point - 1
    return true if text[p] is '\n'
    return true unless text[p]?
    false

  # line end or not
  at_line_end = (text, point) ->
    p = point
    return true if text[p] is '\n'
    return true unless text[p]?
    false

  # tab to indent is neccesary
  key_tab = ->
    now = wrap_text area
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
        write_text area, obj
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
        write_text area, obj
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
      write_text area, obj
    false

  # use shift tab to remove indentation
  key_shift_tab = ->
    now = wrap_text area
    lines = now.lines
    if now.same
      row = now.a_row
      spaces = (lines[row].match /^\s*/)[0]
      space_n = spaces.length
      reduce_n = 2 - spaces%2
      # o lines[row], spaces, space_n, reduce_n
      if space_n >= reduce_n
        lines[row] = lines[row][reduce_n..]
        obj =
          lines: lines
          a_row: row
          a_col: if now.a_col-reduce_n>0 then now.a_col-reduce_n else 0
        write_text area, obj
    else
      sta_row = now.a_row
      end_row = now.b_row
      space_ns = lines[sta_row..end_row].map (line) ->
        spaces = (line.match /^\s*/)[0]
        spaces.length
      # o space_ns
      min_spaces = space_ns.reduce (a, b) -> if a<b then a else b
      # o min_spaces
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
        write_text area, obj
    false

  # select current line (to the end of last line)
  key_ctrl_l = ->
    now = wrap_text area
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
    write_text area, obj
    return false

  # delete form curse to the end of the line
  key_ctrl_k = ->
    now = wrap_text area
    if now.same
      lines = now.lines
      row = now.a_row
      col = now.a_col
      lines[row] = lines[row][0...col]
      obj =
        lines: lines
        a_row: row
        a_col: col
      write_text area, obj
      return false

  # delete form curse to the start of the line, similar to k..
  key_ctrl_u = ->
    now = wrap_text area
    if now.same
      lines = now.lines
      row = now.a_row
      col = now.a_col
      lines[row] = lines[row][col..]
      obj =
        lines: lines
        a_row: row
        a_col: 0
      write_text area, obj
      return false

  # unfocus the textarea
  key_esc =  ->
    do area.blur

  # delete current line
  key_ctrl_shift_k = ->
    now = wrap_text area
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
      write_text area, obj
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
      write_text area, obj
    return false

  # duplicate current line
  key_ctrl_shift_d = ->
    now = wrap_text area
    lines = now.lines
    if now.same
      row = now.a_row
      lines = lines[..row].concat lines[row..]
      obj =
        lines: lines
        a_row: row+1
        a_col: now.a_col
      write_text area, obj
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
      write_text area, obj
    return false

  # enter only, consider last line and
  key_enter = ->
    now = wrap_text area
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
      write_text area, obj
      return false

  # press backspace at head, last line if empty, delete it
  key_backspace = ->
    now = wrap_text area
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
          write_text area, obj
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
          write_text area, obj

  # ctrl Enter to open a new line with indentation
  key_ctrl_enter = ->
    now = wrap_text area
    if now.same
      row = now.a_row
      lines = now.lines
      new_line = (lines[row].match /^\s*/)[0]
      lines = lines[0..row].concat([new_line]).concat lines[row+1..]
      obj =
        lines: lines
        a_row: row + 1
      write_text area, obj

  # ctrl shift Enter nearly the same, but put at above
  key_ctrl_shift_enter = ->
    now = wrap_text area
    if now.same
      row = now.a_row
      lines = now.lines
      new_line = (lines[row].match /^\s*/)[0]
      lines = lines[0...row].concat([new_line]).concat lines[row..]
      obj =
        lines: lines
        a_row: row
      write_text area, obj

  # move current line up
  key_ctrl_shift_up = ->
    now = wrap_text area
    if now.same
      row = now.a_row
      if row > 0
        lines = now.lines
        [lines[row], lines[row-1]] = [lines[row-1], lines[row]]
        obj =
          lines: lines
          a_row: row-1
          a_col: now.a_col
        write_text area, obj
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
        write_text area, obj
    false

  # move current line udown
  key_ctrl_shift_down = ->
    now = wrap_text area
    lines = now.lines
    if now.same
      row = now.a_row
      if row < lines.length - 1
        [lines[row], lines[row+1]] = [lines[row+1], lines[row]]
        obj =
          lines: lines
          a_row: row+1
          a_col: now.a_col
        write_text area, obj
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
        write_text area, obj
    false

  # left-bracket
  key_bracket = (bracket) ->
    now = wrap_text area
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
    write_text area, obj
    return false

  key_bracket_close = (closer) ->
    now = wrap_text area
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
        write_text area, obj
        return false

  # new version of map_keys
  call_shortcut =
    9:  key_tab
    13: key_enter
    8:  key_backspace
    219: -> key_bracket '[]'
    192: -> key_bracket '``'
    222: -> key_bracket "''"
    221: -> key_bracket_close ']'
    'shift 9':      key_shift_tab
    'shift 57':  -> key_bracket '()'
    'shift 48':  -> key_bracket_close ')'
    'shift 219': -> key_bracket '{}'
    'shift 221': -> key_bracket_close '}'
    'shift 222': -> key_bracket '""'
    'ctrl 76': key_ctrl_l
    'ctrl 13': key_ctrl_enter
    'ctrl 75': key_ctrl_k
    'ctrl 85': key_ctrl_u
    'ctrl shift 13': key_ctrl_shift_enter
    'ctrl shift 75': key_ctrl_shift_k
    'ctrl shift 68': key_ctrl_shift_d
    'ctrl shift 38': key_ctrl_shift_up
    'ctrl shift 40': key_ctrl_shift_down

  # new version of event_handler but with object to find the function
  (tag textarea_id).onkeydown = (e) ->
    mark = ''
    mark+= 'alt '   if e.altKey
    mark+= 'ctrl '  if e.ctrlKey
    mark+= 'shift ' if e.shiftKey
    mark+= String e.keyCode
    o mark
    call_shortcut[mark] area if call_shortcut[mark]?