
# take id and find the element
g_id = (tagid) ->
  elem = document.getElementById tagid
  elem

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
  arr = obj.arr
  last_line = arr.length - 1
  last_letter = arr[last_line].length
  a_sta = if obj.a_sta? then obj.a_sta else last_line
  a_end = if obj.a_end? then obj.a_end else last_letter
  b_sta = if obj.b_sta? then obj.b_sta else a_sta
  b_end = if obj.b_end? then obj.b_end else a_end
  area.value = arr.join '\n'
  area.selectionStart = set_position arr, a_sta, a_end
  area.selectionEnd = set_position arr, b_sta, b_end

# change raw and column index to position
set_position = (arr, sta, end) ->
  lines_before_curse = arr[0...sta]
  inline_before_curse = arr[sta][0...end]
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
empty_line = (line) ->
  if (line.match /^\s*$/)? then true else false

# get the end index of a line
line_end = (str) ->
  index = str.length

# get the number of spaces in the indent
indent_n = (str) ->
  count = 0
  while str[0]?
    count += 1 if str[0] is ' '
    str = str[1..]
  count

# about event.keyCode
press =
  enter: 13
  tab: 9
  shift: 16
  alt: 18
  backspace: 8
  l: 108

# send tool to key_handlers
tool =
  wrap_text:  wrap_text
  write_text: write_text
  empty_line: empty_line
  indent_n:   indent_n

# should use new function to add event handler
event_handler = (tagid) ->
  area = g_id tagid
  area.onkeypress = (e) ->
    code = e.keyCode or e.charCode
    shift = e.shiftKey
    alt = e.altKey
    ctrl = e.ctrlKey
    arr = [ctrl, alt, shift, code]
    obj = wrap_text area
    if equal arr, [off, off, off, press.tab  ] then return key_tab              area, tool
    if equal arr, [off, off, off, press.enter] then return key_enter            area, tool
    # with alt key active
    if equal arr, [off, on,  off, press.enter] then return key_alt_enter        area, tool
    # with shift key active
    if equal arr, [off, off, on,  press.tab  ] then return key_shift_tab        area, tool
    if equal arr, [off, off, on,  press.enter] then return key_shift_enter      area, tool
    # with ctrl key active
    if equal arr, [on,  off, off, press.l    ] then return key_ctrl_l           area, tool
    if equal arr, [on,  off, off, press.enter] then return key_ctrl_enter       area, tool
    # with ctrl shift keys active
    if equal arr, [on,  off, on,  press.enter] then return key_ctrl_shift_enter area, tool

# switch dont support well, try function
equal = ([a1, a2, a3, a4], [b1, b2, b3, b4]) ->
  return false unless a1 is b1
  return false unless a2 is b2
  return false unless a3 is b3
  return false unless a4 is b4
  true

# should be placed after function's defining
window.event_handler = event_handler if window?
window.tool = tool