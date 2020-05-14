
require :./main.css

console.log :loaded

var get $ \ (id)
  document.getElementById id
var
  ({}~ codearea) $ require :./codearea

var main $ \ ()
  var paper $ get :paper

  codearea paper
  paper.focus

  = paper.oninput $ \ (event)
    console.log :input $ JSON.stringify event.target.value

= window.onload main
