// function technicians(){ bind click on technicians to open that techs jobs }
// function jobs(technician){ load my jobs into the div and bind click to close jobs list }
// function job(){ iterate thru my jobs and bind click to open that job }
// function pull_job(link){ pull job based on link and throw it in the job div }
// function new_job(){ bind click on new job link to open new job for this tech }
// function bind_closer(){ close everything link binder }
// function close_everything(){ close everything thats open }
// function timer(job_id, link){ setup my start stop hooks }

$().ready(function() {
  // fix technician colors and rollover effect
  $("a.technician").each(function(){
    var color = $(this).attr('color');
    var font_color = $(this).attr('font_color');
    $(this).css({backgroundColor: color, color: font_color, border: "2px solid "+color });
    $(this).hover(
      function(){
        $(this).css({border: "2px solid #000"});
      }, 
      function(){
        $(this).css({border: "2px solid "+color});
      }
    );
  });
  
  // hide my jobs and job divs
  $("div#jobs").hide();
  $("div#job").hide();

  technicians();
  $('#timers').fadeOut("fast").load('/timers', function(){
    $('table.jobs tr').each(function(){
      var bg_color = $(this).attr('bg_color');
      var font_color = $(this).attr('font_color');
      var tds = $(this).children();
      tds.css({backgroundColor: bg_color, color: font_color});
    });
  }).fadeIn("fast");
  var refreshTimers = setInterval(function(){
    $('#timers').fadeOut("fast").load('/timers', function(){
      $('table.jobs tr').each(function(){
        var bg_color = $(this).attr('bg_color');
        var font_color = $(this).attr('font_color');
        var tds = $(this).children();
        tds.css({backgroundColor: bg_color, color: font_color});
      });
    }).fadeIn("fast");
  }, 60000);
  
});

// make link javascript friendly
function cleanse_link(a_tag){
  var link = a_tag.attr('href');
  a_tag.attr('alt', link);
  a_tag.attr('href', 'javascript:void(0)');
};
// bind click on technicians to open that techs jobs
function technicians(){
  $('a.technician').each(function(){
    cleanse_link($(this));
    $(this).bind('click', function(){
      close_everything();
      if($(this).hasClass('new')){
        pull_job($(this));
      }else{
        var technician = $(this);
        jobs(technician);
      };
    });
  });
};
// load my jobs into the div and bind click to close jobs list
function jobs(technician){
  close_everything();
  $("div#jobs").load(technician.attr('alt'), function(){
    bind_closer();
    job();
    new_job();
    $("div#jobs").slideDown("slow");
  });
};
// iterate thru my jobs and bind click to open that job
function job(){
  $('a.job').each(function(){
    $(this).bind('click', function(){
      pull_job($(this));
    });
  });
};
// pull job based on link and throw it in the job div
function pull_job(link){
  $("div#job").slideUp('fast');
  $("div#job").load(link.attr('alt'), function(){
    // pausecomp(1000);
    $("div#job").slideDown("slow", function(){
      $("input#job_ro_number").focus();
      var job_id = $("div#job h2").attr('id');
      timer(job_id, link);
      bind_closer();
      bind_complete(job_id);
      bind_submit();
      bind_edit(job_id);
    });
  });
};
// bind click on new job link to open new job for this tech
function new_job(){
  $("a.new_job").bind('click', function(){
    pull_job($(this));
  });
};
// bind to submit so that we can reload this bugger
function bind_submit(){
  $("input.submit").hide();
  $("a#create_job").bind("click", function(){
    $("input.submit").click();
  });
};
function bind_edit(job_id){
  $("a.edit_job").bind("click", function(){
    $("div#job").slideUp("fast").load('/jobs/'+job_id+'/edit').slideDown('slow');
  });
};
// close everything link binder
function bind_closer(){
  cleanse_link($("a#return_home"))
  $("a#return_home").bind("click", function(){
    close_everything();
  });
};
// close everything thats open
function close_everything(){
  $("div#job").slideUp("fast");
  $("div#jobs").slideUp("fast");
};
// setup my start stop hooks
function timer(job_id, link){
  $("a.toggle_timer").bind("click", function(){
    if ($(this).attr("id")=="start_timer"){
      $.ajax({
        type: "POST",
        url: "/timers",
        data: "timer[job_id]="+job_id,
        success: function(){
          pull_job(link)
        }
      });
    }else{
      $.ajax({
        type: "POST",
        url: "/timers/"+$(this).attr("timer_id"),
        data: "_method=put",
        success: function(){
          pull_job(link)
        }
      });
    }
  });
};
// complete
function bind_complete(job_id){
  $("a#complete_job").bind("click", function(){
    $.ajax({
      type: "POST",
      url: "/jobs/"+job_id,
      data: "_method=put&completed=true",
      success: function(){
        window.location.reload();
      }
    });
  });
};