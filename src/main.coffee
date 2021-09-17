
import "../assets/main.css"

console.log "loaded"
import {codearea} from "./codearea"

get = (id) ->
  document.getElementById id

window.onload = () ->
  paper = get "paper"
  codearea paper
  paper.focus()

  paper.oninput = (event) ->
    console.log "input", (JSON.stringify event.target.value)
