
# about event.keyCode
press =
  enter: 13
  tab: 9
  shift: 16
  alt: 18
  backspace: 8
  l: 108
  k: 107
  K: 75
  esc: 27

window.map_keys = (arr, area, key_equal) ->
  if key_equal arr, [off, off, off, press.tab  ] then return key_tab              area
  if key_equal arr, [off, off, off, press.enter] then return key_enter            area
  if key_equal arr, [off, off, off, press.esc  ] then return key_esc              area
  # with alt key active
  if key_equal arr, [off, on,  off, press.enter] then return key_alt_enter        area
  # with shift key active
  if key_equal arr, [off, off, on,  press.tab  ] then return key_shift_tab        area
  if key_equal arr, [off, off, on,  press.enter] then return key_shift_enter      area
  # with ctrl key active
  if key_equal arr, [on,  off, off, press.l    ] then return key_ctrl_l           area
  if key_equal arr, [on,  off, off, press.enter] then return key_ctrl_enter       area
  if key_equal arr, [on,  off, off, press.k    ] then return key_ctrl_k           area
  # with ctrl shift keys active
  if key_equal arr, [on,  off, on,  press.enter] then return key_ctrl_shift_enter area
  if key_equal arr, [on,  off, on,  press.K    ] then return key_ctrl_shift_K     area