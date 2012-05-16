
tag = (id) -> document.getElementById id

nc2md = (file, silent) ->
  last_line = ''
  md = []
  for line in (file.split '\n')
    if line[0] in ['>', '-', '*', ' ', '+']
      if last_line[0]? and last_line[0] isnt line[0] then md.push ''
    if (match = line.match /^(\S.*)\s*$/)
      md.push if silent then match[1] else match[1]+'  '
    else if (match = line.match /^(\s\s.*)\s*$/) then md.push "  #{match[1]}"
    else md.push line
    last_line = line
  md.join '\n'

put = (str) -> makeHtml (nc2md str, yes)

store = undefined
locked = no

window.onload = ->
  text = tag 'text'
  view = tag 'view'
  text.value = localStorage.text
  text.focus()
  textareaEditor 'text'

  view.innerHTML = put text.value
  text.oninput = -> view.innerHTML = put text.value unless locked

  document.onkeydown = (e) -> if e.keyCode is 27
    if locked
      locked = off
      text.value = store
    else
      locked = on
      store = text.value
      text.value = nc2md store, no
      text.selectionStart = 0
      text.selectionStart = -1

  f = ->
    localStorage.text = text.value
  setInterval f, 100