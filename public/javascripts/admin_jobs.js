$(document).ready(function() {

  // Setup my sidebar, select the section I'm in, etc
  var status = gup("status");
  $("#sidebar ul li a").each(function(){
    if ($(this).attr("class") == status) {
      $(this).parent("li").addClass("selected");
    };
  });

  // delete jobs dialog
  $("#start_date").datepicker();
  $("#end_date").datepicker();
  
  $('div#delete_jobs').dialog({
    autoOpen: false,
    closeOnEscape: true,
		title: "Delete Jobs",
		width: 600,
		height: 220,
		modal: true,
	});
  // open the dialog on click
  $('a#delete_jobs_link').bind('click', function(){
    $('div#delete_jobs').dialog('open');
  });	
});