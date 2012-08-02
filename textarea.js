var even, textareaEditor,
  __slice = Array.prototype.slice;

even = function(n) {
  return n % 2 === 0;
};

textareaEditor = function(textarea_id) {
  var area, at_line_end, at_line_sta, call_shortcut, get_col, get_row, key_backspace, key_bracket, key_bracket_close, key_ctrl_enter, key_ctrl_k, key_ctrl_l, key_ctrl_shift_d, key_ctrl_shift_down, key_ctrl_shift_enter, key_ctrl_shift_k, key_ctrl_shift_up, key_ctrl_u, key_enter, key_esc, key_home, key_shift_tab, key_tab, o, set_position, tag, wrap_text, write_text;
  tag = function(tagid) {
    return document.getElementById(tagid);
  };
  area = tag(textarea_id);
  o = function() {
    var v;
    v = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    return console.log(v);
  };
  wrap_text = function(area) {
    var a_col, a_row, contx, end, lines, obj, sta;
    sta = area.selectionStart;
    end = area.selectionEnd;
    contx = area.value;
    lines = contx.split('\n');
    a_row = get_row(contx, sta);
    a_col = get_col(contx, sta);
    return obj = {
      all: lines,
      row: a_row,
      col: a_col,
      lines: lines,
      a_row: a_row,
      a_col: a_col,
      a_sta: at_line_sta(contx, sta),
      a_end: at_line_end(contx, sta),
      b_row: get_row(contx, end),
      b_col: get_col(contx, end),
      b_sta: at_line_sta(contx, end),
      b_end: at_line_end(contx, end),
      same: sta === end
    };
  };
  write_text = function(area, obj) {
    var a_col, a_row, arr, b_col, b_row, end_line;
    arr = obj.lines.length > 0 ? obj.lines : [''];
    end_line = arr.length - 1;
    a_row = obj.a_row != null ? obj.a_row : end_line;
    a_col = obj.a_col != null ? obj.a_col : arr[a_row].length;
    b_row = obj.b_row != null ? obj.b_row : a_row;
    if (obj.b_col != null) {
      b_col = obj.b_col;
    } else {
      if (obj.b_row != null) {
        b_col = arr[b_row].length;
      } else {
        b_col = a_col;
      }
    }
    area.value = arr.join('\n');
    area.selectionStart = set_position(arr, a_row, a_col);
    return area.selectionEnd = set_position(arr, b_row, b_col);
  };
  set_position = function(arr, row, col) {
    var inline_before_curse, lines_before_curse, position, text_before_curse;
    lines_before_curse = arr.slice(0, row);
    inline_before_curse = arr[row] != null ? arr[row].slice(0, col) : '';
    lines_before_curse.push(inline_before_curse);
    text_before_curse = lines_before_curse.join('\n');
    return position = text_before_curse.length;
  };
  get_row = function(str, point) {
    var count, i, _i, _len;
    count = 0;
    str = str.slice(0, point);
    for (_i = 0, _len = str.length; _i < _len; _i++) {
      i = str[_i];
      if (i === '\n') count += 1;
    }
    return count;
  };
  get_col = function(str, point) {
    var last, n, sub_str;
    str = str.slice(0, point);
    last = str.lastIndexOf('\n');
    last += 1;
    sub_str = str.slice(last);
    return n = sub_str.length;
  };
  at_line_sta = function(text, point) {
    var p;
    p = point - 1;
    if (text[p] === '\n') return true;
    if (text[p] == null) return true;
    return false;
  };
  at_line_end = function(text, point) {
    var p;
    p = point;
    if (text[p] === '\n') return true;
    if (text[p] == null) return true;
    return false;
  };
  key_tab = function() {
    var add_n, end_line, index, lines, now, obj, row, space_n, spaces, sta_line;
    now = wrap_text(area);
    if (now.same) {
      lines = now.lines;
      row = now.a_row;
      if (now.a_sta && row > 0 && lines[row - 1].match(/^\s+/)) {
        spaces = (lines[row - 1].match(/^\s+/))[0];
        space_n = spaces.length;
        lines[row] = spaces + lines[row];
        obj = {
          lines: lines,
          a_row: row,
          a_col: space_n
        };
        write_text(area, obj);
      } else {
        spaces = (lines[row].match(/^\s*/))[0];
        space_n = spaces.length;
        add_n = 2 - space_n % 2;
        if (add_n === 1) {
          lines[row] = '\ ' + lines[row];
        } else {
          lines[row] = '\ \ ' + lines[row];
        }
        obj = {
          lines: lines,
          a_row: row,
          a_col: now.a_col + add_n
        };
        write_text(area, obj);
      }
    } else {
      sta_line = now.a_row;
      end_line = now.b_row;
      lines = now.lines;
      for (index = sta_line; sta_line <= end_line ? index <= end_line : index >= end_line; sta_line <= end_line ? index++ : index--) {
        lines[index] = '\ \ ' + lines[index];
      }
      obj = {
        lines: lines,
        a_row: sta_line,
        a_col: now.a_col,
        b_row: end_line,
        b_col: now.b_col + 2
      };
      write_text(area, obj);
    }
    return false;
  };
  key_shift_tab = function() {
    var end_row, index, lines, min_spaces, now, obj, reduce_n, row, space_n, space_ns, spaces, sta_row;
    now = wrap_text(area);
    lines = now.lines;
    if (now.same) {
      row = now.a_row;
      spaces = (lines[row].match(/^\s*/))[0];
      space_n = spaces.length;
      reduce_n = 2 - spaces % 2;
      if (space_n >= reduce_n) {
        lines[row] = lines[row].slice(reduce_n);
        obj = {
          lines: lines,
          a_row: row,
          a_col: now.a_col - reduce_n > 0 ? now.a_col - reduce_n : 0
        };
        write_text(area, obj);
      }
    } else {
      sta_row = now.a_row;
      end_row = now.b_row;
      space_ns = lines.slice(sta_row, end_row + 1 || 9e9).map(function(line) {
        spaces = (line.match(/^\s*/))[0];
        return spaces.length;
      });
      min_spaces = space_ns.reduce(function(a, b) {
        if (a < b) {
          return a;
        } else {
          return b;
        }
      });
      if (min_spaces > 0) {
        reduce_n = 2 - min_spaces % 2;
        for (index = sta_row; sta_row <= end_row ? index <= end_row : index >= end_row; sta_row <= end_row ? index++ : index--) {
          lines[index] = lines[index].slice(reduce_n);
        }
        obj = {
          lines: lines,
          a_row: sta_row,
          a_col: now.a_col - reduce_n,
          b_row: end_row,
          b_col: now.b_col - reduce_n
        };
        write_text(area, obj);
      }
    }
    return false;
  };
  key_ctrl_l = function() {
    var a_col, a_row, now, obj;
    now = wrap_text(area);
    a_row = now.a_row;
    a_col = 0;
    if (now.lines[a_row - 1] != null) {
      a_row -= 1;
      a_col = void 0;
    }
    obj = {
      lines: now.lines,
      a_row: a_row,
      a_col: a_col,
      b_row: now.b_row
    };
    write_text(area, obj);
    return false;
  };
  key_ctrl_k = function() {
    var col, lines, now, obj, row;
    now = wrap_text(area);
    if (now.same) {
      lines = now.lines;
      row = now.a_row;
      col = now.a_col;
      lines[row] = lines[row].slice(0, col);
      obj = {
        lines: lines,
        a_row: row,
        a_col: col
      };
      write_text(area, obj);
      return false;
    }
  };
  key_ctrl_u = function() {
    var col, lines, now, obj, row;
    now = wrap_text(area);
    if (now.same) {
      lines = now.lines;
      row = now.a_row;
      col = now.a_col;
      lines[row] = lines[row].slice(col);
      obj = {
        lines: lines,
        a_row: row,
        a_col: 0
      };
      write_text(area, obj);
      return false;
    }
  };
  key_esc = function() {
    return area.blur();
  };
  key_ctrl_shift_k = function() {
    var a_col, a_row, end_row, lines, now, obj, row, sta_row;
    now = wrap_text(area);
    if (now.same) {
      row = now.a_row;
      lines = now.lines;
      lines = lines.slice(0, row).concat(lines.slice(row + 1));
      a_row = row;
      a_col = 0;
      if (row !== 0) {
        a_row = row - 1;
        a_col = void 0;
      }
      obj = {
        lines: lines,
        a_row: a_row,
        a_col: a_col
      };
      write_text(area, obj);
    } else {
      sta_row = now.a_row;
      end_row = now.b_row;
      lines = now.lines;
      o('origin lines: ', lines);
      lines = lines.slice(0, sta_row).concat(lines.slice(end_row + 1));
      o('after; ', lines);
      a_row = sta_row > 0 ? sta_row - 1 : 0;
      obj = {
        lines: lines,
        a_row: a_row
      };
      o(obj);
      write_text(area, obj);
    }
    return false;
  };
  key_ctrl_shift_d = function() {
    var duplicate, end_row, lines, now, obj, row, sta_row;
    now = wrap_text(area);
    lines = now.lines;
    if (now.same) {
      row = now.a_row;
      lines = lines.slice(0, row + 1 || 9e9).concat(lines.slice(row));
      obj = {
        lines: lines,
        a_row: row + 1,
        a_col: now.a_col
      };
      write_text(area, obj);
    } else {
      sta_row = now.a_row;
      end_row = now.b_row;
      lines = lines.slice(0, end_row + 1 || 9e9).concat(lines.slice(sta_row));
      duplicate = end_row - sta_row + 1;
      obj = {
        lines: lines,
        a_row: sta_row + duplicate,
        a_col: now.a_col,
        b_row: end_row + duplicate,
        b_col: now.b_col
      };
      write_text(area, obj);
    }
    return false;
  };
  key_enter = function() {
    var col, lines, now, obj, row, space_n, spaces;
    now = wrap_text(area);
    if (now.same) {
      row = now.a_row;
      col = now.a_col;
      lines = now.lines;
      lines = lines.slice(0, row + 1 || 9e9).concat(lines.slice(row));
      lines[row] = lines[row].slice(0, col);
      spaces = (lines[row].match(/^\s*/))[0];
      space_n = spaces.length;
      lines[row + 1] = spaces + lines[row + 1].slice(col);
      obj = {
        lines: lines,
        a_row: row + 1,
        a_col: space_n
      };
      write_text(area, obj);
      return false;
    }
  };
  key_backspace = function() {
    var lines, n, now, obj, pair, row;
    now = wrap_text(area);
    if (now.same) {
      row = now.a_row;
      lines = now.lines;
      if (lines[row].slice(0, now.a_col).match(/^\s+$/)) {
        n = lines[row].slice(0, now.a_col).length;
        if (even(n)) {
          lines[row] = lines[row].slice(0, (n - 2)) + lines[row].slice(n);
        } else {
          lines[row] = lines[row].slice(0, (n - 1)) + lines[row].slice(n);
        }
        obj = {
          lines: lines,
          a_row: row,
          a_col: n - 2
        };
        write_text(area, obj);
        return false;
      } else if ((lines[row - 1] != null) && now.a_sta) {
        if (lines[row - 1].match(/^\s+$/)) {
          lines = lines.slice(0, (row - 1)).concat(lines.slice(row));
          obj = {
            lines: lines,
            a_row: row - 1,
            a_col: 0
          };
          write_text(area, obj);
          return false;
        }
      }
      if (lines[row].length > 1 && (!now.a_end)) {
        pair = lines[row].slice(now.a_col - 1, now.a_col + 1 || 9e9);
        if (pair === '{}' || pair === '()' || pair === '[]' || pair === '""' || pair === "''" || pair === '``') {
          lines[row] = lines[row].slice(0, now.a_col) + lines[row].slice(now.a_col + 1);
          obj = {
            lines: lines,
            a_row: now.a_row,
            a_col: now.b_col
          };
          return write_text(area, obj);
        }
      }
    }
  };
  key_ctrl_enter = function() {
    var lines, new_line, now, obj, row;
    now = wrap_text(area);
    if (now.same) {
      row = now.a_row;
      lines = now.lines;
      new_line = (lines[row].match(/^\s*/))[0];
      lines = lines.slice(0, row + 1 || 9e9).concat([new_line]).concat(lines.slice(row + 1));
      obj = {
        lines: lines,
        a_row: row + 1
      };
      return write_text(area, obj);
    }
  };
  key_ctrl_shift_enter = function() {
    var lines, new_line, now, obj, row;
    now = wrap_text(area);
    if (now.same) {
      row = now.a_row;
      lines = now.lines;
      new_line = (lines[row].match(/^\s*/))[0];
      lines = lines.slice(0, row).concat([new_line]).concat(lines.slice(row));
      obj = {
        lines: lines,
        a_row: row
      };
      return write_text(area, obj);
    }
  };
  key_ctrl_shift_up = function() {
    var end_row, index, line, lines, now, obj, row, sta_row, t_line, _len, _ref, _ref2;
    now = wrap_text(area);
    if (now.same) {
      row = now.a_row;
      if (row > 0) {
        lines = now.lines;
        _ref = [lines[row - 1], lines[row]], lines[row] = _ref[0], lines[row - 1] = _ref[1];
        obj = {
          lines: lines,
          a_row: row - 1,
          a_col: now.a_col
        };
        write_text(area, obj);
      }
    } else {
      sta_row = now.a_row;
      end_row = now.b_row;
      if (sta_row > 0) {
        lines = now.lines;
        t_line = lines[sta_row - 1];
        _ref2 = lines.slice(sta_row, end_row + 1 || 9e9);
        for (index = 0, _len = _ref2.length; index < _len; index++) {
          line = _ref2[index];
          lines[sta_row + index - 1] = line;
        }
        lines[end_row] = t_line;
        obj = {
          lines: lines,
          a_row: sta_row - 1,
          a_col: now.a_col,
          b_row: end_row - 1,
          b_col: now.b_col
        };
        write_text(area, obj);
      }
    }
    return false;
  };
  key_ctrl_shift_down = function() {
    var end_row, index, line, lines, now, obj, row, sta_row, t_line, _len, _ref, _ref2;
    now = wrap_text(area);
    lines = now.lines;
    if (now.same) {
      row = now.a_row;
      if (row < lines.length - 1) {
        _ref = [lines[row + 1], lines[row]], lines[row] = _ref[0], lines[row + 1] = _ref[1];
        obj = {
          lines: lines,
          a_row: row + 1,
          a_col: now.a_col
        };
        write_text(area, obj);
      }
    } else {
      sta_row = now.a_row;
      end_row = now.b_row;
      if (end_row < lines.length - 1) {
        t_line = lines[end_row + 1];
        _ref2 = lines.slice(sta_row, end_row + 1 || 9e9);
        for (index = 0, _len = _ref2.length; index < _len; index++) {
          line = _ref2[index];
          lines[sta_row + index + 1] = line;
        }
        lines[sta_row] = t_line;
        obj = {
          lines: lines,
          a_row: sta_row + 1,
          a_col: now.a_col,
          b_row: end_row + 1,
          b_col: now.b_col
        };
        write_text(area, obj);
      }
    }
    return false;
  };
  key_bracket = function(bracket) {
    var a_col, a_row, b_col, b_row, lines, now, obj;
    now = wrap_text(area);
    lines = now.lines;
    a_row = now.a_row;
    a_col = now.a_col;
    b_row = now.b_row;
    b_col = now.b_col;
    lines[b_row] = lines[b_row].slice(0, b_col) + bracket[1] + lines[b_row].slice(b_col);
    lines[a_row] = lines[a_row].slice(0, a_col) + bracket[0] + lines[a_row].slice(a_col);
    obj = {
      lines: lines,
      a_row: a_row,
      a_col: a_col + 1,
      b_row: b_row,
      b_col: b_col + 1
    };
    write_text(area, obj);
    return false;
  };
  key_bracket_close = function(closer) {
    var col, lines, now, obj, row, target;
    now = wrap_text(area);
    if (now.same) {
      row = now.a_row;
      col = now.a_col;
      lines = now.lines;
      target = lines[row][col];
      if ((target != null) && target === closer) {
        obj = {
          lines: lines,
          a_row: row,
          a_col: col + 1
        };
        write_text(area, obj);
        return false;
      }
    }
  };
  key_home = function() {
    var col, lines, now, obj, row, spaces;
    now = wrap_text(area);
    if (now.same) {
      lines = now.lines;
      row = now.a_row;
      col = now.a_col;
      spaces = lines[row].match(/^\s+/);
      obj = {
        lines: lines,
        a_row: row,
        a_col: spaces[0] != null ? spaces[0].length : 0
      };
      write_text(area, obj);
      return false;
    }
  };
  call_shortcut = {
    9: key_tab,
    13: key_enter,
    8: key_backspace,
    36: key_home,
    219: function() {
      return key_bracket('[]');
    },
    192: function() {
      return key_bracket('``');
    },
    222: function() {
      return key_bracket("''");
    },
    221: function() {
      return key_bracket_close(']');
    },
    'shift 9': key_shift_tab,
    'shift 57': function() {
      return key_bracket('()');
    },
    'shift 48': function() {
      return key_bracket_close(')');
    },
    'shift 219': function() {
      return key_bracket('{}');
    },
    'shift 221': function() {
      return key_bracket_close('}');
    },
    'shift 222': function() {
      return key_bracket('""');
    },
    'ctrl 76': key_ctrl_l,
    'ctrl 13': key_ctrl_enter,
    'ctrl 75': key_ctrl_k,
    'ctrl 85': key_ctrl_u,
    'ctrl shift 13': key_ctrl_shift_enter,
    'ctrl shift 75': key_ctrl_shift_k,
    'ctrl shift 68': key_ctrl_shift_d,
    'ctrl shift 38': key_ctrl_shift_up,
    'ctrl shift 40': key_ctrl_shift_down
  };
  return (tag(textarea_id)).onkeydown = function(e) {
    var mark;
    mark = '';
    if (e.altKey) mark += 'alt ';
    if (e.ctrlKey) mark += 'ctrl ';
    if (e.shiftKey) mark += 'shift ';
    mark += String(e.keyCode);
    o(mark);
    if (call_shortcut[mark] != null) return call_shortcut[mark](area);
  };
};