
even = (n) -> n % 2 is 0

# output function o
o = (v...) -> console.log v

# function to get the row index
get_row = (str, point) ->
  count = 0
  str = str[...point]
  count += 1 for i in str when i is '\n'
  count

# main idea, to wrap text to all in object
wrap_text = (target) ->
  sta = target.selectionStart
  end = target.selectionEnd
  contx = target.value
  all = contx.split '\n'
  ar = get_row contx, sta
  ac = get_col contx, sta
  obj =
    row: ar
    col: ac
    all: all
    ar: ar
    ac: ac
    as: at_line_sta contx, sta
    ae: at_line_end contx, sta
    br: get_row     contx, end
    bc: get_col     contx, end
    bs: at_line_sta contx, end
    be: at_line_end contx, end
    same:  sta is end

# have args about text, implement it
write_text = (target, obj) ->
  arr = if obj.all.length > 0 then obj.all else ['']
  # o obj
  end_line = arr.length - 1
  ar = if obj.ar? then obj.ar else end_line
  ac = if obj.ac? then obj.ac else arr[ar].length
  br = if obj.br? then obj.br else ar
  if obj.bc? then bc = obj.bc
  else
    if obj.br? then bc = arr[br].length
    else bc = ac
  # o '4: ', ar, ac, br, bc, obj.bc
  target.value = arr.join '\n'
  target.selectionStart = set_position arr, ar, ac
  target.selectionEnd = set_position arr, br, bc
  false

# change raw and column index to position
set_position = (arr, row, col) ->
  all_before_curse = arr[0...row]
  inline_before_curse = if arr[row]? then arr[row][0...col] else ''
  all_before_curse.push inline_before_curse
  text_before_curse = all_before_curse.join '\n'
  position = text_before_curse.length

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
key_tab = (target, event) ->
  event.preventDefault()

  caret = wrap_text target
  # o caret
  {all,ar,ac,br,bc} = caret
  if caret.same
    if caret.as and ar > 0 and all[ar-1].match /^\s+/
      spaces = (all[ar-1].match /^\s+/)[0]
      all[ar] = spaces + all[ar]
      ac = spaces.length
      write_text target, {all,ar,ac}
    else
      spaces = (all[ar].match /^\s*/)[0]
      space_n = spaces.length
      add_n = 2 - space_n%2
      if add_n is 1
        all[ar] = '\ '+all[ar]
      else
        all[ar] = '\ \ '+all[ar]
      ac += add_n
      write_text target, {all,ar,ac}
  else
    ar = caret.ar
    br = caret.br
    for index in [ar..br]
      all[index] = '\ \ '+all[index]
    ac += 2
    bc += 2
    write_text target, {all,ar,ac,br,bc}

# use shift tab to remove indentation
key_shift_tab = (target, event) ->
  event.preventDefault()

  caret = wrap_text target
  {all,ar,ac,br,bc} = caret
  if caret.same
    ar = caret.ar
    spaces = (all[ar].match /^\s*/)[0]
    space_n = spaces.length
    reduce_n = 2 - spaces%2
    # o all[ar], spaces, space_n, reduce_n
    if space_n >= reduce_n
      all[ar] = all[ar][reduce_n..]
      obj =
        all: all
        ar: ar
      ac = if ac-reduce_n>0 then ac-reduce_n else 0
      write_text target, {all,ar,ac}
  else
    space_ns = all[ar..br].map (line) ->
      spaces = (line.match /^\s*/)[0]
      spaces.length
    # o space_ns
    min_spaces = space_ns.reduce (a, b) -> if a<b then a else b
    # o min_spaces
    if min_spaces > 0
      reduce_n = 2 - min_spaces%2
      for index in [ar..br]
        all[index] = all[index][reduce_n..]
      ac -= reduce_n
      bc -= reduce_n
      write_text target, {all,ar,ac,br,bc}

# select current line (to the end of last line)
key_ctrl_l = (target) ->
  caret = wrap_text target
  {all,ar,br,bc} = caret
  ac = 0
  if all[ar-1]?
    ar -= 1
    ac = undefined
  write_text target, {all,ar,ac,br,bc}

# delete form curse to the end of the line
key_ctrl_k = (target) ->
  caret = wrap_text target
  if caret.same
    {all,ar,ac} = caret
    all[ar] = all[ar][0...ac]
    write_text target, {all,ar,ac}

# delete form curse to the start of the line, similar to k..
key_ctrl_u = (target) ->
  caret = wrap_text target
  if caret.same
    {all,ar,ac} = caret
    all[ar] = all[ar][ac..]
    ac = 0
    write_text target, {all,ar,ac}

# unfocus the textarea
key_esc = (target) ->
  do area.blur

# delete current line
key_ctrl_shift_k = (target) ->
  caret = wrap_text target
  {all,ar,br} = caret
  if caret.same
    all = all[...ar].concat all[ar+1..]
    # o all
    ac = 0
    if ar isnt 0
      ar -= 1
      ac = undefined
    write_text target, {all,ar,ac}
  else
    # o 'origin all: ', all
    all = all[...ar].concat all[br+1..]
    # o 'after; ', all
    ar = if ar>0 then ar-1 else 0
    write_text target, {all,ar}

# duplicate current line
key_ctrl_shift_d = (target) ->
  caret = wrap_text target
  {all,ar,ac,br,bc} = caret
  if caret.same
    all = all[..ar].concat all[ar..]
    ar += 1
    write_text target, {all,ar,ac}
  else
    all = all[..br].concat all[ar..]
    duplicate = br - ar + 1
    ar += duplicate
    br += duplicate
    write_text target, {all,ar,ac,br,bc}

# enter only, consider last line and
key_enter = (target, event) ->
  event.preventDefault()

  caret = wrap_text target
  {all,ar,ac} = caret
  if caret.same
    all = all[..ar].concat all[ar..]
    line = all[ar]
    all[ar] = all[ar][...ac]
    spaces = (all[ar].match /^\s*/)[0]
    all[ar+1] = spaces + line[ac..]
    # o all
    ac = spaces.length
    ar += 1
    write_text target, {all,ar,ac}

# press backspace at head, last line if empty, delete it
key_backspace = (target, event) ->

  caret = wrap_text target
  {all,ar,ac} = caret
  if caret.same
    if all[ar][...ac].match /^\s+$/
      n = all[ar][...ac].length
      if even n then all[ar] = all[ar][...n-2] + all[ar][n..]
      else all[ar] = all[ar][...n-1] + all[ar][n..]
      ac = n - 2
      event.preventDefault()
      write_text target, {all,ar,ac}
    else if all[ar-1]? and caret.as
      if all[ar-1].match /^\s+$/
        all = all[...ar-1].concat all[ar..]
        ar = ar-1
        ac = 0
        event.preventDefault()
        write_text target, {all,ar,ac}
    # o caret.ae
    else if all[ar].length>1 and (not caret.ae)
      pair = all[ar][ac-1..ac]
      # o pair
      if pair in ['{}', '()', '[]', '""', "''", '``']
        all[ar] = all[ar][...ac-1] + all[ar][ac+1..]
        ac -= 1
        event.preventDefault()
        write_text target, {all,ar,ac}

# ctrl Enter to open a new line with indentation
key_ctrl_enter = (target) ->
  caret = wrap_text target
  {all,ar} = caret
  if caret.same
    new_line = (all[ar].match /^\s*/)[0]
    all = all[0..ar].concat([new_line]).concat all[ar+1..]
    ar += 1
    write_text target, {all,ar}

# ctrl shift Enter nearly the same, but put at above
key_ctrl_shift_enter = (target) ->
  caret = wrap_text target
  {all,ar} = caret
  if caret.same
    new_line = (all[ar].match /^\s*/)[0]
    all = all[0...ar].concat([new_line]).concat all[ar..]
    write_text target, {all,ar}

# move current line up
key_ctrl_shift_up = (target) ->
  caret = wrap_text target
  {all,ar,ac,br,bc} = caret
  if caret.same
    if ar > 0
      [all[ar], all[ar-1]] = [all[ar-1], all[ar]]
      ar -= 1
      write_text target, {all,ar,ac}
  else
    if ar > 0
      t_line = all[ar-1]
      for line, index in all[ar..br]
        all[ar+index-1] = line
      all[br] = t_line
      ar -= 1
      br -= 1
      write_text target, {all,ar,ac,br,bc}

# move current line udown
key_ctrl_shift_down = (target) ->
  caret = wrap_text target
  {all,ar,ac,bc,br} = caret
  if caret.same
    if ar < all.length - 1
      [all[ar], all[ar+1]] = [all[ar+1], all[ar]]
      ar += 1
      write_text target, {all,ar,ac}
  else
    if br < all.length - 1
      t_line = all[br+1]
      for line, index in all[ar..br]
        all[ar+index+1] = line
      all[ar] = t_line
      ar += 1
      br += 1
      write_text target, {all,ar,ac,br,bc}

# left-bracket
key_bracket = (target, event, bracket) ->
  event.preventDefault()

  caret = wrap_text target
  {all,ac,ar,br,bc} = caret
  # o bracket
  all[br] = all[br][...bc] + bracket[1] + all[br][bc..]
  all[ar] = all[ar][...ac] + bracket[0] + all[ar][ac..]
  # o all[0]
  ac += 1
  bc += 1
  write_text target, {all,ar,ac,br,bc}

key_bracket_close = (target, event, closer) ->
  event.preventDefault()

  caret = wrap_text target
  {all,ar,ac} = caret
  if caret.same
    target = all[ar][ac]
    if target? and target is closer
      ac += 1
      write_text target, {all,ar,ac}

key_home = (target) ->
  caret = wrap_text target
  if caret.same
    {all, ar, ac} = caret
    spaces = all[ar].match /^\s+/
    ac = if spaces? then spaces[0].length else 0
    write_text target, {all, ar, ac}

key_quote = (target, event, sign) ->
  event.preventDefault()

  caret = wrap_text target
  if caret.same
    {all, ar, ac} = caret
    line = all[ar]
    unless line[ac] is sign
      all[ar] = line[...ac] + sign + sign + line[ac..]
    ac += 1
    write_text target, {all, ar, ac}
  else
    {all,ar,ac,br,bc} = caret
    line = all[ar]
    all[ar] = line[...ac] + sign + line[ac..]
    ac += 1
    bc += 1 if ar is br
    line = all[br]
    all[br] = line[...bc] + sign + line[bc..]
    write_text target, {all,ar,ac,br,bc}

# new version of map_keys
call_shortcut =
  9: (target, event) -> key_tab target, event
  13: (target, event) -> key_enter target, event
  8: (target, event) -> key_backspace target, event
  36: (target) -> key_home target
  219: (target, event) -> key_bracket target, event, '[]'
  192: (target, event) -> key_quote target, event, '`'
  # 222: (target, event) -> key_quote target, event, "'"
  221: (target, event) -> key_bracket_close target, event, ']'
  'shift 9': (target, event) -> key_shift_tab target, event
  'shift 57': (target, event) -> key_bracket target, event, '()'
  'shift 48': (target, event) -> key_bracket_close target, event, ')'
  'shift 219': (target, event) -> key_bracket target, event, '{}'
  'shift 221': (target, event) -> key_bracket_close target, event, '}'
  'shift 222': (target, event) -> key_quote target, event, '"'
  'ctrl 76': (target) -> key_ctrl_l target
  'ctrl 13': (target, event) -> key_ctrl_enter target, event
  'ctrl 75': (target) -> key_ctrl_k target
  'ctrl 85': (target) -> key_ctrl_u target
  'ctrl shift 13': (target, event) -> key_ctrl_shift_enter target, event
  'ctrl shift 75': (target) -> key_ctrl_shift_k target
  'ctrl shift 68': (target) -> key_ctrl_shift_d target
  'ctrl shift 38': (target) -> key_ctrl_shift_up target
  'ctrl shift 40': (target) -> key_ctrl_shift_down target

exports.codearea = (area) ->
  if not area?
    throw new Error "expected an element as area, but got undefined"

  if area.tagName isnt 'TEXTAREA'
    throw new Error "expected an textarea element, but got #{area.tagName}"

  if area.__codearea__?
    console.warn "Already initialized as codearea"
    return

  # new version of event_handler but with object to find the function
  handleEvents = (e) ->
    mark = ''
    mark+= 'alt '   if e.altKey
    mark+= 'ctrl '  if e.ctrlKey
    mark+= 'shift ' if e.shiftKey
    mark+= String e.keyCode
    # o mark
    call_shortcut[mark] area, e if call_shortcut[mark]?

  area.__codearea__ = handleEvents

  area.addEventListener 'keydown', handleEvents

exports.teardownCodearea = (area) ->
  if not area.__codearea__?
    console.warn area, 'is not a textarea'
    return

  area.removeEventListner 'keydown', area.__codearea__
  area.__codearea__
