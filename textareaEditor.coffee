
textareaEditor = (target_id) ->
  # take id and find the element
  g_id = (tagid) -> document.getElementById tagid

  # output function o
  o = (v...) -> console.log v

  # main idea, to wrap text to lines in object
  wrap_text = (area) ->
    start = area.selectionStart
    end = area.selectionEnd
    contx = area.value
    lines = contx.split '\n'
    obj =
      lines: lines
      a_row: get_row     contx, start
      a_col: get_column  contx, start
      a_sta: at_line_sta contx, start
      a_end: at_line_end contx, start
      b_row: get_row     contx, end
      b_col: get_column  contx, end
      b_sta: at_line_sta contx, end
      b_end: at_line_end contx, end
      same:  start is end
      tail:  lines.length - 1

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
  get_column = (str, point) ->
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

  # check empty line
  line_empty = (line) ->
    if (line.match /^\s*$/)? then true else false

  # get the number of spaces in the indent
  indent_n = (str) ->
    count = 0
    while str[0]?
      count += 1 if str[0] is ' '
      str = str[1..]
    count

  # send tool to key_handlers
  tool =
    wrap_text: wrap_text
    write_text: write_text
    line_empty: line_empty
    indent_n: indent_n

  # should use new function to add event handler
  event_handler = (tagid) ->
    area = g_id tagid
    area.onkeydown = (e) ->
      code = e.keyCode or e.charCode
      o e.keyCode, e.charCode, '::', code
      shift = e.shiftKey
      alt = e.altKey
      ctrl = e.ctrlKey
      arr = [ctrl, alt, shift, code]
      return map_keys arr, area, key_equal

  # switch dont support well, try function
  key_equal = ([a1, a2, a3, a4], [b1, b2, b3, b4]) ->
    return false unless a1 is b1
    return false unless a2 is b2
    return false unless a3 is b3
    return false unless a4 is b4
    true

  # should be placed after function's defining
  # window.event_handler = event_handler if window?
  # window.global_sharing_tools = tool


  #============================


  # o = (v...) -> console.log v
  # tool = global_sharing_tools

  # tab to indent is neccesary
  key_tab = (area) ->
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
  key_shift_tab = (area) ->
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
  key_ctrl_l = (area) ->
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
  key_ctrl_k = (area) ->
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
  key_ctrl_u = (area) ->
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
  key_esc = (area) ->
    do area.blur

  # delete current line
  key_ctrl_shift_k = (area) ->
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
  key_ctrl_shift_d = (area) ->
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
  key_enter = (area) ->
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
  key_backspace = (area) ->
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
  key_ctrl_enter = (area) ->
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
  key_ctrl_shift_enter = (area) ->
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
  key_ctrl_shift_up = (area) ->
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
  key_ctrl_shift_down = (area) ->
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
  
  ###
  # go to the begining of whole page
  key_ctrl_home = (area) ->
    now = tool.wrap_text area
    if now.same
      obj =
        lines: now.lines
        a_row: 0
        a_col: 0
      tool.write_text area, obj

  # go to the end of whole page
  key_ctrl_end = (area) ->
    now = tool.wrap_text area
    if now.same
      lines = now.lines
      obj =
        lines: lines
        a_row: lines.length - 1
      tool.write_text area, obj
  ###

  # left-bracket
  key_bracket = (area, bracket) ->
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

  key_bracket_close = (area, closer) ->
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


  # =======================


  # about event.keyCode
  press =
    enter: 13
    tab: 9
    shift: 16
    alt: 18
    backspace: 8
    l: 76
    k: 75
    esc: 27
    d: 68
    u: 85
    up: 38
    down: 40
    home: 36
    end: 35
    n9: 57
    n0: 48
    squBrac: 219
    squBraC: 221
    quote: 222
    backquote: 192

  map_keys = (arr, area, key_equal) ->
    if key_equal arr, [off, off, off, press.tab      ] then return key_tab              area
    if key_equal arr, [off, off, off, press.enter    ] then return key_enter            area
    if key_equal arr, [off, off, off, press.esc      ] then return key_esc              area
    if key_equal arr, [off, off, off, press.backspace] then return key_backspace        area
    if key_equal arr, [off, off, off, press.squBrac  ] then return key_bracket          area, '[]'
    if key_equal arr, [off, off, off, press.quote    ] then return key_bracket          area, "''"
    if key_equal arr, [off, off, off, press.backquote] then return key_bracket          area, '``'
    if key_equal arr, [off, off, off, press.squBraC  ] then return key_bracket_close    area, ']'
    # with alt key active
    if key_equal arr, [off, on,  off, press.enter    ] then return key_alt_enter        area
    # with shift key active
    if key_equal arr, [off, off, on,  press.tab      ] then return key_shift_tab        area
    if key_equal arr, [off, off, on,  press.enter    ] then return key_shift_enter      area
    if key_equal arr, [off, off, on,  press.n9       ] then return key_bracket          area, '()'
    if key_equal arr, [off, off, on,  press.n0       ] then return key_bracket_close    area, ')'
    if key_equal arr, [off, off, on,  press.squBraC  ] then return key_bracket_close    area, '}'
    if key_equal arr, [off, off, on,  press.squBrac  ] then return key_bracket          area, '{}'
    if key_equal arr, [off, off, on,  press.quote    ] then return key_bracket          area, '""'
    # with ctrl key active
    if key_equal arr, [on,  off, off, press.l        ] then return key_ctrl_l           area
    if key_equal arr, [on,  off, off, press.enter    ] then return key_ctrl_enter       area
    if key_equal arr, [on,  off, off, press.k        ] then return key_ctrl_k           area
    if key_equal arr, [on,  off, off, press.u        ] then return key_ctrl_u           area
    # if key_equal arr, [on,  off, off, press.home     ] then return key_ctrl_home        area
    # if key_equal arr, [on,  off, off, press.end      ] then return key_ctrl_end         area
    # with ctrl shift keys active
    if key_equal arr, [on,  off, on,  press.enter    ] then return key_ctrl_shift_enter area
    if key_equal arr, [on,  off, on,  press.k        ] then return key_ctrl_shift_k     area
    if key_equal arr, [on,  off, on,  press.d        ] then return key_ctrl_shift_d     area
    if key_equal arr, [on,  off, on,  press.up       ] then return key_ctrl_shift_up    area
    if key_equal arr, [on,  off, on,  press.down     ] then return key_ctrl_shift_down  area

  # do it!
  event_handler target_id