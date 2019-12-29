
require :./main.css

console.log :loaded

var get $ \ (id)
  document.getElementById id
var
  (object~ codearea) $ require :./codearea

var main $ \ ()
  var paper $ get :paper

  codearea paper
  paper.focus

= window.onload main
