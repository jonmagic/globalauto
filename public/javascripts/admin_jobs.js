$().ready(function() {

  // Setup my sidebar, select the section I'm in, etc
  var status = gup("status");
  $("#sidebar ul li a").each(function(){
    if ($(this).attr("class") == status) {
      $(this).parent("li").addClass("selected");
    };
  });

});


$.fn.timecalc = function(insert_selector){
  // find my values, only requires that there be two fields inside the selector
  // one with a class of hours, and one with minutes
  var hours = $(this).find(".hours").val()>=0 ? $(this).find(".hours").val() : 0;
  var minutes = $(this).find(".minutes").val()>=0 ? $(this).find(".minutes").val() : 0;
  // calculate the total time in minutes
  var total_time_in_minutes = hours*60 + minutes*1;
  // insert the value into the field defined by .timecalc(options)
  $(insert_selector).val(total_time_in_minutes);
};