import "../assets/main.css";

console.log("loaded");

import { codearea } from "./codearea";

let get = function (id: string) {
  return document.getElementById(id);
};

window.onload = function () {
  let paper = get("paper") as HTMLTextAreaElement;
  codearea(paper);
  paper.focus();
  return (paper.oninput = function (event) {
    return console.log(
      "input",
      JSON.stringify((event.target as HTMLTextAreaElement).value)
    );
  });
};
