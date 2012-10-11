
define (require, exports) ->
  get = (id) -> document.getElementById id

  paper = get 'paper'

  {codearea} = require './codearea.coffee'

  codearea paper

  return