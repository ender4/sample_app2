// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function() {
  /*
  function pluralize(str, count) {
    if (count == 1)
      return count + " " + str;
    else
      return count + " " + str + "s";
  }
  $("textarea#micropost_content").keypress(function() {
    var chars = 140 - $("textarea#micropost_content").text().length;
    var message = pluralize("character", chars) + " left";
    if (chars < 0) {
      chars = chars * -1;
      message = "too long remove " + pluralize("character", chars);
    }
    $("div.counter").text(message);
  });
  */
  $("#micropost_content").charCounter(140, {
    container: "div.counter"
  });
});
