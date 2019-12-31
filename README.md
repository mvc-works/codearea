
Codearea Script
----

> Make `<textarea/>`s a bit like `<codearea/>`.

### Usage

![](https://img.shields.io/npm/v/@mvc-works/codearea.svg)

```bash
yarn add @mvc-works/codearea
```

Put the `textareaEditor.js` file in the `<script>` tag of your page.
Suppose there's tag `<textarea id='area'>` here, use this in your `.js` file:

```coffee
import { codearea } from "@mvc-works/codearea"

codearea(textareaElement)

# remove events
teardownCodearea(textareaElement)
```

Try here: http://repo.mvc-works.org/codearea/

### Details

influenced shortcuts:

```
enter
tab
esc
backspace
quote
brackets

shift enter
shift tab

ctrl l
ctrl u
ctrl k
ctrl enter

ctrl shift enter
ctrl shift k
ctrl shift d
ctrl shift up
ctrl shift down
```

### Chinese Docs

上面`JS`的目标是给`<textarea>`标签增加基本的编程功能支持,
主要是一些快捷键, 模仿`Sublime Text`的功能, 还有自动补全括号和缩进,
具体可以到链接尝试, 在`Chrome`中运行测试运行正常,
主要是__获取光标位置的`API`__和__绑定键盘事件的`API`__有差别.
大致思路是用`wrap_text`函数将文本框内容包装成按列处理的对象,
之后通过事件触发`map_keys`选取对应的`key_*`函数处理对象的内容,
最后`write_text`将对象转化回到文本写入.

性能能再优化下, 不清楚对于长文本是否会有延迟, 目前还可以,
`departed_files`是前期的代码, 有些历史文档, 但不再被维护.

### License

MIT
