$(document).ready(function() {
  // set the background color on each technician
  $("a.technician").each(function(){
    var color = $(this).attr("color");
    $(this).css({backgroundColor: color})
  });
});
  