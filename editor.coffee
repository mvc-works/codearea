
# main idea, to wrap text to lines in object
editor = (tagid) ->
  area = g_id tagid
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
  count += 1 if i is '\n' for i in str
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

# take id and find the element
g_id = (tagid) ->
  elem = document.getElementById tagid
  elem

# output function o
o = (v...) -> console.log v

# main behavior, using jQuery
window.onload = ->
  editor 'area'
  area = g_id 'area'
  area.onclick = ->
    obj = editor 'area'
    o obj.a_row, obj.a_column
    o obj.a_start, obj.a_end
    o obj.b_row, obj.b_column
    o obj.b_start, obj.b_end