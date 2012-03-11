
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
  o '4: ', a_row, a_col, b_row, b_col, obj.b_col
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
window.event_handler = event_handler if window?
window.global_sharing_tools = tool