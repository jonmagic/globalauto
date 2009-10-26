$(document).ready(function() {

  function Path() {
    var url = window.location.href;
    url_array = url.split("/");
    return url_array[url_array.length -1];
  }

  // Setup my sidebar, select the section I'm in, etc
  $("#sidebar ul li a").each(function(){
    if ($(this).attr("class") == Path()) {
      $(this).parent("li").addClass("selected");
    };
  });
  
  // table color override
  $("table.itu tr").removeClass("even");
  $("table.itu tr").removeClass("odd");


});