$().ready(function() {

  // Setup my sidebar, select the section I'm in, etc
  var status = gup("status");
  $("#sidebar ul li a").each(function(){
    if ($(this).attr("class") == status) {
      $(this).parent("li").addClass("selected");
    };
  });

});