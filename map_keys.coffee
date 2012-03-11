
# about event.keyCode
press =
  enter: 13
  tab: 9
  shift: 16
  alt: 18
  backspace: 8
  l: 76
  k: 75
  esc: 27
  d: 68
  u: 85

window.map_keys = (arr, area, key_equal) ->
  if key_equal arr, [off, off, off, press.tab      ] then return key_tab              area
  if key_equal arr, [off, off, off, press.enter    ] then return key_enter            area
  if key_equal arr, [off, off, off, press.esc      ] then return key_esc              area
  if key_equal arr, [off, off, off, press.backspace] then return key_backspace        area
  # with alt key active
  if key_equal arr, [off, on,  off, press.enter    ] then return key_alt_enter        area
  # with shift key active
  if key_equal arr, [off, off, on,  press.tab      ] then return key_shift_tab        area
  if key_equal arr, [off, off, on,  press.enter    ] then return key_shift_enter      area
  # with ctrl key active
  if key_equal arr, [on,  off, off, press.l        ] then return key_ctrl_l           area
  if key_equal arr, [on,  off, off, press.enter    ] then return key_ctrl_enter       area
  if key_equal arr, [on,  off, off, press.k        ] then return key_ctrl_k           area
  if key_equal arr, [on,  off, off, press.u        ] then return key_ctrl_u           area
  # with ctrl shift keys active
  if key_equal arr, [on,  off, on,  press.enter    ] then return key_ctrl_shift_enter area
  if key_equal arr, [on,  off, on,  press.k        ] then return key_ctrl_shift_k     area
  if key_equal arr, [on,  off, on,  press.d        ] then return key_ctrl_shift_d     area