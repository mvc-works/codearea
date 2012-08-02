
get = (id) -> document.getElementById id
n = (str) -> (str.match /^\s*/)[0].length

add_left = (str, x) ->
  x /= 2
  left = n str
  [1..x].forEach ->
    str = str[...left] + '(' + str[left..]
  str
add_right = (str, x) ->
  x /= 2
  [1..x].forEach -> str = str + ')'
  str

convert = (str) ->
  lines = str.split '\n'
  for item, index in lines
    n9 = if lines[index-1]? then n lines[index-1] else 0
    n0 = n lines[index]
    n1 = if lines[index+1]? then n lines[index+1] else 0
    console.log n0
    if n1 > n0
      lines[index] = add_left lines[index], (n1 - n0)
    if n0 > n1
      lines[index] = add_right lines[index], (n0 - n1)
    unless n1 > n0
      unless lines[index].trim().length is 0
        unless lines[index].trimLeft()[0] is ';'
          lines[index] = add_left lines[index], 1
          lines[index] = add_right lines[index], 1
  lines.join '\n'

window.onload = ->
  text = get 'text'
  res = get 'res'
  textareaEditor 'text'
  text.oninput = ->
    res.value = convert text.value
  do text.oninput