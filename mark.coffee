
event_handler 'area'
area = document.getElementById 'area'
draw = document.getElementById 'draw'
area.onmouseout = (e) ->
  make = (new Showdown.converter).makeHtml
  draw.innerHTML = make area.value