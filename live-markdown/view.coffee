
tag = (id) -> document.getElementById id

chars = ['>', '-', '*', ' ', '+']
ss = '  '

nc2md = (file) ->
  list = file.split '\n'
  list = list.map (line) ->
    line = line.trimRight()
    if line.lenth <= 2 then line
    else
      line = if line[0..1] is ss then ss+line else line+ss
  copy = []
  normal = true
  for line in list
    plain =
      if not line[0]? then undefined else
        if line[0] in chars then false else true
    copy.push '' unless plain is normal
    normal = plain
    copy.push line
  copy.join '\n'

put = (str) -> marked (nc2md str)

store = undefined
locked = no

window.onload = ->
  text = tag 'text'
  view = tag 'view'
  text.value = localStorage.text
  text.focus()
  textareaEditor 'text'

  view.innerHTML = put text.value
  text.onkeyup = ->
    view.innerHTML = put text.value unless locked

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