
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
  up: 38
  down: 40
  home: 36
  end: 35
  n9: 57
  n0: 48
  squBrac: 219
  squBraC: 221
  quote: 222
  backquote: 192

window.map_keys = (arr, area, key_equal) ->
  if key_equal arr, [off, off, off, press.tab      ] then return key_tab              area
  if key_equal arr, [off, off, off, press.enter    ] then return key_enter            area
  if key_equal arr, [off, off, off, press.esc      ] then return key_esc              area
  if key_equal arr, [off, off, off, press.backspace] then return key_backspace        area
  if key_equal arr, [off, off, off, press.squBrac  ] then return key_bracket          area, '[]'
  if key_equal arr, [off, off, off, press.quote    ] then return key_bracket          area, "''"
  if key_equal arr, [off, off, off, press.backquote] then return key_bracket          area, '``'
  if key_equal arr, [off, off, off, press.squBraC  ] then return key_bracket_close    area, ']'
  # with alt key active
  if key_equal arr, [off, on,  off, press.enter    ] then return key_alt_enter        area
  # with shift key active
  if key_equal arr, [off, off, on,  press.tab      ] then return key_shift_tab        area
  if key_equal arr, [off, off, on,  press.enter    ] then return key_shift_enter      area
  if key_equal arr, [off, off, on,  press.n9       ] then return key_bracket          area, '()'
  if key_equal arr, [off, off, on,  press.n0       ] then return key_bracket_close    area, ')'
  if key_equal arr, [off, off, on,  press.squBraC  ] then return key_bracket_close    area, '}'
  if key_equal arr, [off, off, on,  press.squBrac  ] then return key_bracket          area, '{}'
  if key_equal arr, [off, off, on,  press.quote    ] then return key_bracket          area, '""'
  # with ctrl key active
  if key_equal arr, [on,  off, off, press.l        ] then return key_ctrl_l           area
  if key_equal arr, [on,  off, off, press.enter    ] then return key_ctrl_enter       area
  if key_equal arr, [on,  off, off, press.k        ] then return key_ctrl_k           area
  if key_equal arr, [on,  off, off, press.u        ] then return key_ctrl_u           area
  if key_equal arr, [on,  off, off, press.home     ] then return key_ctrl_home        area
  if key_equal arr, [on,  off, off, press.end      ] then return key_ctrl_end         area
  # with ctrl shift keys active
  if key_equal arr, [on,  off, on,  press.enter    ] then return key_ctrl_shift_enter area
  if key_equal arr, [on,  off, on,  press.k        ] then return key_ctrl_shift_k     area
  if key_equal arr, [on,  off, on,  press.d        ] then return key_ctrl_shift_d     area
  if key_equal arr, [on,  off, on,  press.up       ] then return key_ctrl_shift_up    area
  if key_equal arr, [on,  off, on,  press.down     ] then return key_ctrl_shift_down  area