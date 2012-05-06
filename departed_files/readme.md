
Live demo [here](http://docview.cnodejs.net/projects/textareaEditor/editor.html?html),  

I'm tring to make textarea more like a code area, just some basic features like  
indentation, auto indent, delete line, move line, etc. ,  

There are three configure files:
`map_key.coffee`: list the available shortcuts, most of them haven't been deployed yet  
`editor.coffee`: basic functions to handle lines of content,  
`key_handler.coffee`: the behavior of shortcuts  

The schedule is like this:  

* apply `event_handler` to the `id` of a `<textarea>` element,  
* when event was caught, `map_keys` will choose the spection function to response,  
* use `tool.wrap_text` to abstract(?...) the text, return as an object,  
* analyze the object(as `now`), create a new object names `obj` of the result,  
* use `tool.write_text` to draw texts in the `<textarea>`  

When adding new shortcuts:  

* lookup the `map_key.coffee` to fill in details  
* define the behavior at `key_handler.coffee` with `wrap_text` and `write_text`  

Now we got:  

* ESC  -- blur from textarea  
* Tab  -- indentation using 2(or 1) tabs  
* Shift Tab  -- remove indentation one step  
* Ctrl l  -- select line  
* Ctrl Enter  -- new line with indentation  
* Ctrl u  -- remove the words inline before the curse  
* Ctrl k  -- remove words after the curse in the same line  
* Ctrl Shift Up  -- move lines up  
* Ctrl Shift Down  -- move lines down  
* Ctrl Shift k  -- remove current line  
* Ctrl Shift d  -- duplicate current line  

英文写得我都无语了, 当成正则这类勉强能看懂的, 吧?  
我将代码分离成 3 个文件了, 算是目前我最像话的代码了, 之前高兴还乐了会  
但是后面想加上补全之类的就发现这个模型有点幼稚了.. 再说吧, 上不上还是问题  
如果要进行扩展, 要先用`wrap_text`获取`textarea`的内容, 返回一个处理过的对象  
然后`tool`对象有些函数能处理文本的, 用处不大, 这里主要是修改`lines`  
然后生成一个`obj`, 省略的位置参数接口上做了设计, 比如`b`默认取`a`的, `col`空白表示末尾的  
传给`write_text`之后, 代为写入, 我目前所做的就是这些了  
