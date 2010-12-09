// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function() {
  
  $("#micropost_content").charCounter(140, {
    container: "#micropost_counter"
  });
  
});
