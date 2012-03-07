
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
  obj =
    lines: contx.split '\n'
    a_row: get_row contx, start
    a_column: get_column contx, start
    a_start: line_start contx, start
    a_end: line_end contx, start
    b_row: get_row contx, end
    b_column: get_column contx, end
    b_start: line_start contx, end
    b_end: line_end contx, end
    same: start is end

# function to get the row index
get_row = (str, point) ->
  count = 0
  str = str[...point]
  o str
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
line_start = (text, point) ->
  p = point - 1
  return true if text[p] is '\n'
  return true unless text[p]?
  false

# line end or not
line_end = (text, point) ->
  p = point
  return true if text[p] is '\n'
  return true unless text[p]?
  false

# check empty line
empty_line = (line) ->
  if (line.match /^\s*$/)? then true else false

# about event.keyCode
press =
  enter: 13
  tab: 9
  shift: 16
  alt: 18
  backspace: 8
  l: 108

# should use new function to add event handler
event_handler = (tagid) ->
  area = g_id tagid
  area.onkeypress = (e) ->
    code = e.keyCode or e.charCode
    shift = e.shiftKey
    alt = e.altKey
    ctrl = e.ctrlKey
    arr = [ctrl, alt, shift, code]
    if equal arr, [off, off, off, press.tab]
      o 'tab'
      return false
    if equal arr, [off, off, on, press.tab]
      o 'shift tab'
      return false
    if equal arr, [off, off, off, press.enter]
      o 'enter'
      return false
    if equal arr, [off, off, on, press.enter]
      o 'shift enter'
      return false
    if equal arr, [on, off, off, press.enter]
      o 'ctrl enter'
      return false
    if equal arr, [on, off, on, press.enter]
      o 'ctrl shift enter'
      return false
    if equal arr, [off, on, off, press.enter]
      o 'alt enter'
      return false

# switch dont support well, try function
equal = ([a1, a2, a3, a4], [b1, b2, b3, b4]) ->
  return false unless a1 is b1
  return false unless a2 is b2
  return false unless a3 is b3
  return false unless a4 is b4
  true

# have args about text, implement it
write_text = (area, arr, start, end) ->
  o 'work for the coming day....'

# should be placed after function's defining
window.event_handler = event_handler if window?