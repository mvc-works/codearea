
event_handler 'area'
area = document.getElementById 'area'
draw = document.getElementById 'draw'
make = (new Showdown.converter).makeHtml
draw.innerHTML = make area.value
area.onmouseout = (e) ->
  draw.innerHTML = make area.value
