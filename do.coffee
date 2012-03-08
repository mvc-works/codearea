
event_handler 'area'
window.area = document.getElementById 'area'
(document.getElementById 'debug').onclick = (e) ->
  area.focus()
  tool.write_text area, arr: ['324324','234234'], a_sta: 1, a_end: 1