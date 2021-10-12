let even = function (n: number) {
  return n % 2 === 0;
};

// output function o
let o = function (...v: any[]) {
  return console.log(v);
};

// function to get the row index
let get_row = function (str: string, point: number) {
  let count = 0;
  str = str.slice(0, point);
  for (let j = 0, len = str.length; j < len; j++) {
    let i = str[j];
    if (i === "\n") {
      count += 1;
    }
  }
  return count;
};

let triggerInput = function (element: HTMLTextAreaElement) {
  var event;
  event = new Event("input", {
    bubbles: true,
    cancelable: true,
  });
  return element.dispatchEvent(event);
};

interface TextInfo {
  row: number;
  col: number;
  all: string[];
  ar: number;
  ac: number;
  as: boolean;
  ae: boolean;
  br: number;
  bc: number;
  bs: boolean;
  be: boolean;
  same: boolean;
}

// main idea, to wrap text to all in object
let wrap_text = function (target: HTMLTextAreaElement): TextInfo {
  let sta = target.selectionStart;
  let end = target.selectionEnd;
  let contx = target.value;
  let all = contx.split("\n");
  let ar = get_row(contx, sta);
  let ac = get_col(contx, sta);
  return {
    row: ar,
    col: ac,
    all: all,
    ar: ar,
    ac: ac,
    as: at_line_sta(contx, sta),
    ae: at_line_end(contx, sta),
    br: get_row(contx, end),
    bc: get_col(contx, end),
    bs: at_line_sta(contx, end),
    be: at_line_end(contx, end),
    same: sta === end,
  };
};

// have args about text, implement it
let write_text = function (
  target: HTMLTextAreaElement,
  obj: Partial<TextInfo>
) {
  let arr = obj.all.length > 0 ? obj.all : [""];
  // o obj
  let end_line = arr.length - 1;
  let ar = obj.ar != null ? obj.ar : end_line;
  let ac = obj.ac != null ? obj.ac : arr[ar].length;
  let br = obj.br != null ? obj.br : ar;
  var bc;
  if (obj.bc != null) {
    bc = obj.bc;
  } else {
    if (obj.br != null) {
      bc = arr[br].length;
    } else {
      bc = ac;
    }
  }
  // o '4: ', ar, ac, br, bc, obj.bc
  target.value = arr.join("\n");
  target.selectionStart = set_position(arr, ar, ac);
  target.selectionEnd = set_position(arr, br, bc);
  triggerInput(target);
  return false;
};

// change raw and column index to position
let set_position = function (arr: string[], row: number, col: number) {
  let all_before_curse = arr.slice(0, row);
  let inline_before_curse = arr[row] != null ? arr[row].slice(0, col) : "";
  all_before_curse.push(inline_before_curse);
  let text_before_curse = all_before_curse.join("\n");
  return text_before_curse.length;
};

// function to get column index
let get_col = function (str: string, point: number) {
  str = str.slice(0, point);
  let last = str.lastIndexOf("\n");
  last += 1;
  let sub_str = str.slice(last);
  return sub_str.length;
};

// line start or not
let at_line_sta = function (text: string, point: number) {
  let p = point - 1;
  if (text[p] === "\n") {
    return true;
  }
  if (text[p] == null) {
    return true;
  }
  return false;
};

// line end or not
let at_line_end = function (text: string, point: number) {
  let p = point;
  if (text[p] === "\n") {
    return true;
  }
  if (text[p] == null) {
    return true;
  }
  return false;
};

// tab to indent is neccesary
let key_tab = function (target: HTMLTextAreaElement, event: Event) {
  event.preventDefault();
  let caret = wrap_text(target);
  // o caret
  let { all, ar, ac, br, bc } = caret;
  if (caret.same) {
    if (caret.as && ar > 0 && all[ar - 1].match(/^\s+/)) {
      let spaces = all[ar - 1].match(/^\s+/)[0];
      all[ar] = spaces + all[ar];
      ac = spaces.length;
      return write_text(target, { all, ar, ac });
    } else {
      let spaces = all[ar].match(/^\s*/)[0];
      let space_n = spaces.length;
      let add_n = 2 - (space_n % 2);
      if (add_n === 1) {
        all[ar] = " " + all[ar];
      } else {
        all[ar] = "  " + all[ar];
      }
      ac += add_n;
      return write_text(target, { all, ar, ac });
    }
  } else {
    ar = caret.ar;
    br = caret.br;
    let ref, j;
    for (
      let index = (j = ref = ar), ref1 = br;
      ref <= ref1 ? j <= ref1 : j >= ref1;
      index = ref <= ref1 ? ++j : --j
    ) {
      all[index] = "  " + all[index];
    }
    ac += 2;
    bc += 2;
    return write_text(target, { all, ar, ac, br, bc });
  }
};

// use shift tab to remove indentation
let key_shift_tab = function (target: HTMLTextAreaElement, event: Event) {
  event.preventDefault();
  let caret = wrap_text(target);
  let { all, ar, ac, br, bc } = caret;
  if (caret.same) {
    ar = caret.ar;
    let spaces = all[ar].match(/^\s*/)[0];
    let space_n = spaces.length;
    let reduce_n = 2 - (space_n % 2);
    // o all[ar], spaces, space_n, reduce_n
    if (space_n >= reduce_n) {
      all[ar] = all[ar].slice(reduce_n);
      let obj = {
        all: all,
        ar: ar,
      };
      ac = ac - reduce_n > 0 ? ac - reduce_n : 0;
      return write_text(target, { all, ar, ac });
    }
  } else {
    let space_ns = all.slice(ar, +br + 1 || 9e9).map(function (line) {
      let spaces = line.match(/^\s*/)[0];
      return spaces.length;
    });
    // o space_ns
    let min_spaces = space_ns.reduce(function (a, b) {
      if (a < b) {
        return a;
      } else {
        return b;
      }
    });
    // o min_spaces
    if (min_spaces > 0) {
      let reduce_n = 2 - (min_spaces % 2);
      var ref;
      var j;
      for (
        let index = (j = ref = ar), ref1 = br;
        ref <= ref1 ? j <= ref1 : j >= ref1;
        index = ref <= ref1 ? ++j : --j
      ) {
        all[index] = all[index].slice(reduce_n);
      }
      ac -= reduce_n;
      bc -= reduce_n;
      return write_text(target, { all, ar, ac, br, bc });
    }
  }
};

// select current line (to the end of last line)
let key_ctrl_l = function (target: HTMLTextAreaElement) {
  let caret = wrap_text(target);
  let { all, ar, br, bc } = caret;
  let ac = 0;
  if (all[ar - 1] != null) {
    ar -= 1;
    ac = void 0;
  }
  return write_text(target, { all, ar, ac, br, bc });
};

// delete form curse to the end of the line
let key_ctrl_k = function (target: HTMLTextAreaElement) {
  let caret = wrap_text(target);
  if (caret.same) {
    let { all, ar, ac } = caret;
    all[ar] = all[ar].slice(0, ac);
    return write_text(target, { all, ar, ac });
  }
};

// delete form curse to the start of the line, similar to k..
let key_ctrl_u = function (target: HTMLTextAreaElement) {
  let caret = wrap_text(target);
  if (caret.same) {
    let { all, ar, ac } = caret;
    all[ar] = all[ar].slice(ac);
    ac = 0;
    return write_text(target, { all, ar, ac });
  }
};

// unfocus the textarea
let key_esc = function (target: HTMLTextAreaElement) {
  return target.blur();
};

// delete current line
let key_ctrl_shift_k = function (target: HTMLTextAreaElement) {
  let caret = wrap_text(target);
  let { all, ar, br } = caret;
  if (caret.same) {
    all = all.slice(0, ar).concat(all.slice(ar + 1));
    // o all
    let ac = 0;
    if (ar !== 0) {
      ar -= 1;
      ac = void 0;
    }
    return write_text(target, { all, ar, ac });
  } else {
    // o 'origin all: ', all
    all = all.slice(0, ar).concat(all.slice(br + 1));
    // o 'after; ', all
    ar = ar > 0 ? ar - 1 : 0;
    return write_text(target, { all, ar });
  }
};

// duplicate current line
let key_ctrl_shift_d = function (target: HTMLTextAreaElement) {
  let caret = wrap_text(target);
  let { all, ar, ac, br, bc } = caret;
  if (caret.same) {
    all = all.slice(0, +ar + 1 || 9e9).concat(all.slice(ar));
    ar += 1;
    return write_text(target, { all, ar, ac });
  } else {
    all = all.slice(0, +br + 1 || 9e9).concat(all.slice(ar));
    let duplicate = br - ar + 1;
    ar += duplicate;
    br += duplicate;
    return write_text(target, { all, ar, ac, br, bc });
  }
};

// enter only, consider last line and
let key_enter = function (target: HTMLTextAreaElement, event: Event) {
  var ac, all, ar, caret, line, spaces;
  event.preventDefault();
  caret = wrap_text(target);
  ({ all, ar, ac } = caret);
  if (caret.same) {
    all = all.slice(0, +ar + 1 || 9e9).concat(all.slice(ar));
    line = all[ar];
    all[ar] = all[ar].slice(0, ac);
    spaces = all[ar].match(/^\s*/)[0];
    all[ar + 1] = spaces + line.slice(ac);
    // o all
    ac = spaces.length;
    ar += 1;
    return write_text(target, { all, ar, ac });
  }
};

// press backspace at head, last line if empty, delete it
let key_backspace = function (target: HTMLTextAreaElement, event: Event) {
  var ac, all, ar, caret, n, pair;
  caret = wrap_text(target);
  ({ all, ar, ac } = caret);
  if (caret.same) {
    if (all[ar].slice(0, ac).match(/^\s+$/)) {
      n = all[ar].slice(0, ac).length;
      if (even(n)) {
        all[ar] = all[ar].slice(0, n - 2) + all[ar].slice(n);
      } else {
        all[ar] = all[ar].slice(0, n - 1) + all[ar].slice(n);
      }
      ac = n - 2;
      event.preventDefault();
      return write_text(target, { all, ar, ac });
    } else if (all[ar - 1] != null && caret.as) {
      if (all[ar - 1].match(/^\s+$/)) {
        all = all.slice(0, ar - 1).concat(all.slice(ar));
        ar = ar - 1;
        ac = 0;
        event.preventDefault();
        return write_text(target, { all, ar, ac });
      }
      // o caret.ae
    } else if (all[ar].length > 1 && !caret.ae) {
      pair = all[ar].slice(ac - 1, +ac + 1 || 9e9);
      // o pair
      if (
        pair === "{}" ||
        pair === "()" ||
        pair === "[]" ||
        pair === '""' ||
        pair === "''" ||
        pair === "``"
      ) {
        all[ar] = all[ar].slice(0, ac - 1) + all[ar].slice(ac + 1);
        ac -= 1;
        event.preventDefault();
        return write_text(target, { all, ar, ac });
      }
    }
  }
};

// ctrl Enter to open a new line with indentation
let key_ctrl_enter = function (target: HTMLTextAreaElement) {
  var all, ar, caret, new_line;
  caret = wrap_text(target);
  ({ all, ar } = caret);
  if (caret.same) {
    new_line = all[ar].match(/^\s*/)[0];
    all = all
      .slice(0, +ar + 1 || 9e9)
      .concat([new_line])
      .concat(all.slice(ar + 1));
    ar += 1;
    return write_text(target, { all, ar });
  }
};

// ctrl shift Enter nearly the same, but put at above
let key_ctrl_shift_enter = function (target: HTMLTextAreaElement) {
  var all, ar, caret, new_line;
  caret = wrap_text(target);
  ({ all, ar } = caret);
  if (caret.same) {
    new_line = all[ar].match(/^\s*/)[0];
    all = all.slice(0, ar).concat([new_line]).concat(all.slice(ar));
    return write_text(target, { all, ar });
  }
};

// move current line up
let key_ctrl_shift_up = function (target: HTMLTextAreaElement) {
  var ac, all, ar, bc, br, caret, index, j, len, line, ref, t_line;
  caret = wrap_text(target);
  ({ all, ar, ac, br, bc } = caret);
  if (caret.same) {
    if (ar > 0) {
      [all[ar], all[ar - 1]] = [all[ar - 1], all[ar]];
      ar -= 1;
      return write_text(target, { all, ar, ac });
    }
  } else {
    if (ar > 0) {
      t_line = all[ar - 1];
      ref = all.slice(ar, +br + 1 || 9e9);
      for (index = j = 0, len = ref.length; j < len; index = ++j) {
        line = ref[index];
        all[ar + index - 1] = line;
      }
      all[br] = t_line;
      ar -= 1;
      br -= 1;
      return write_text(target, { all, ar, ac, br, bc });
    }
  }
};

// move current line udown
let key_ctrl_shift_down = function (target: HTMLTextAreaElement) {
  var ac, all, ar, bc, br, caret, index, j, len, line, ref, t_line;
  caret = wrap_text(target);
  ({ all, ar, ac, bc, br } = caret);
  if (caret.same) {
    if (ar < all.length - 1) {
      [all[ar], all[ar + 1]] = [all[ar + 1], all[ar]];
      ar += 1;
      return write_text(target, { all, ar, ac });
    }
  } else {
    if (br < all.length - 1) {
      t_line = all[br + 1];
      ref = all.slice(ar, +br + 1 || 9e9);
      for (index = j = 0, len = ref.length; j < len; index = ++j) {
        line = ref[index];
        all[ar + index + 1] = line;
      }
      all[ar] = t_line;
      ar += 1;
      br += 1;
      return write_text(target, { all, ar, ac, br, bc });
    }
  }
};

// left-bracket
let key_bracket = function (
  target: HTMLTextAreaElement,
  event: Event,
  bracket: string
) {
  var ac, all, ar, bc, br, caret;
  event.preventDefault();
  caret = wrap_text(target);
  ({ all, ac, ar, br, bc } = caret);
  // o bracket
  all[br] = all[br].slice(0, bc) + bracket[1] + all[br].slice(bc);
  all[ar] = all[ar].slice(0, ac) + bracket[0] + all[ar].slice(ac);
  // o all[0]
  ac += 1;
  bc += 1;
  return write_text(target, { all, ar, ac, br, bc });
};

let key_bracket_close = function (
  target: HTMLTextAreaElement,
  event: Event,
  closer: string
) {
  var ac, all, ar, caret;
  event.preventDefault();
  caret = wrap_text(target);
  ({ all, ar, ac } = caret);
  if (caret.same) {
    let tt = all[ar][ac];
    if (tt != null && tt === closer) {
      ac += 1;
      return write_text(target, { all, ar, ac });
    }
  }
};

let key_home = function (target: HTMLTextAreaElement) {
  var ac, all, ar, caret, spaces;
  caret = wrap_text(target);
  if (caret.same) {
    ({ all, ar, ac } = caret);
    spaces = all[ar].match(/^\s+/);
    ac = spaces != null ? spaces[0].length : 0;
    return write_text(target, { all, ar, ac });
  }
};

let key_quote = function (
  target: HTMLTextAreaElement,
  event: Event,
  sign: string
) {
  event.preventDefault();
  let caret = wrap_text(target);
  if (caret.same) {
    let { all, ar, ac } = caret;
    let line = all[ar];
    if (line[ac] !== sign) {
      all[ar] = line.slice(0, ac) + sign + sign + line.slice(ac);
    }
    ac += 1;
    return write_text(target, { all, ar, ac });
  } else {
    let { all, ar, ac, br, bc } = caret;
    let line = all[ar];
    all[ar] = line.slice(0, ac) + sign + line.slice(ac);
    ac += 1;
    if (ar === br) {
      bc += 1;
    }
    line = all[br];
    all[br] = line.slice(0, bc) + sign + line.slice(bc);
    return write_text(target, { all, ar, ac, br, bc });
  }
};

// new version of map_keys
let call_shortcut = {
  9: function (target: HTMLTextAreaElement, event: Event) {
    return key_tab(target, event);
  },
  13: function (target: HTMLTextAreaElement, event: Event) {
    return key_enter(target, event);
  },
  8: function (target: HTMLTextAreaElement, event: Event) {
    return key_backspace(target, event);
  },
  36: function (target: HTMLTextAreaElement) {
    return key_home(target);
  },
  219: function (target: HTMLTextAreaElement, event: Event) {
    return key_bracket(target, event, "[]");
  },
  192: function (target: HTMLTextAreaElement, event: Event) {
    return key_quote(target, event, "`");
  },
  // 222: (target, event) -> key_quote target, event, "'"
  221: function (target: HTMLTextAreaElement, event: Event) {
    return key_bracket_close(target, event, "]");
  },
  "shift 9": function (target: HTMLTextAreaElement, event: Event) {
    return key_shift_tab(target, event);
  },
  "shift 57": function (target: HTMLTextAreaElement, event: Event) {
    return key_bracket(target, event, "()");
  },
  "shift 48": function (target: HTMLTextAreaElement, event: Event) {
    return key_bracket_close(target, event, ")");
  },
  "shift 219": function (target: HTMLTextAreaElement, event: Event) {
    return key_bracket(target, event, "{}");
  },
  "shift 221": function (target: HTMLTextAreaElement, event: Event) {
    return key_bracket_close(target, event, "}");
  },
  "shift 222": function (target: HTMLTextAreaElement, event: Event) {
    return key_quote(target, event, '"');
  },
  "ctrl 76": function (target: HTMLTextAreaElement) {
    return key_ctrl_l(target);
  },
  "ctrl 13": function (target: HTMLTextAreaElement, event: Event) {
    return key_ctrl_enter(target);
  },
  "ctrl 75": function (target: HTMLTextAreaElement) {
    return key_ctrl_k(target);
  },
  "ctrl 85": function (target: HTMLTextAreaElement) {
    return key_ctrl_u(target);
  },
  "ctrl shift 13": function (target: HTMLTextAreaElement, event: Event) {
    return key_ctrl_shift_enter(target);
  },
  "ctrl shift 75": function (target: HTMLTextAreaElement) {
    return key_ctrl_shift_k(target);
  },
  "ctrl shift 68": function (target: HTMLTextAreaElement) {
    return key_ctrl_shift_d(target);
  },
  "ctrl shift 38": function (target: HTMLTextAreaElement) {
    return key_ctrl_shift_up(target);
  },
  "ctrl shift 40": function (target: HTMLTextAreaElement) {
    return key_ctrl_shift_down(target);
  },
};

export var codearea = function (area: HTMLTextAreaElement) {
  var handleEvents;
  if (area == null) {
    throw new Error("expected an element as area, but got undefined");
  }
  if (area.tagName !== "TEXTAREA") {
    throw new Error(`expected an textarea element, but got ${area.tagName}`);
  }
  if ((area as any).__codearea__ != null) {
    console.warn("Already initialized as codearea");
    return;
  }
  // new version of event_handler but with object to find the function
  handleEvents = function (e: KeyboardEvent) {
    var mark;
    mark = "";
    if (e.altKey) {
      mark += "alt ";
    }
    if (e.ctrlKey) {
      mark += "ctrl ";
    }
    if (e.shiftKey) {
      mark += "shift ";
    }
    mark += String(e.keyCode);
    if ((call_shortcut as any)[mark] != null) {
      // o mark
      return (call_shortcut as any)[mark](area, e);
    }
  };
  (area as any).__codearea__ = handleEvents;
  return area.addEventListener("keydown", handleEvents);
};

export var teardownCodearea = function (area: HTMLTextAreaElement) {
  if ((area as any).__codearea__ == null) {
    console.warn(area, "is not a textarea");
    return;
  }
  area.removeEventListener("keydown", (area as any).__codearea__);
  return (area as any).__codearea__;
};
