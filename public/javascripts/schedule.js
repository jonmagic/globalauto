function draw_job(job, units){
  if(job.timers.length > 0){
    $.each(job.timers, function(){draw_timer(this, job, units)});
  }else{
    if(job.flatrate_time){
      var difference = job.flatrate_time*60;
    }else{
      var difference = 60;
    }
    var dimensions = get_dimensions(units, job.scheduled_at, difference, job.technician_id);
    if($('div#'+job.id).length == 0){
      $('body').append('<div class="job" id="'+job.id+'"><h2>RO# '+job.ro+'<span>'+job.lastname+'</span></h2><p>'+job.description+'</p><span class="ui-icon ui-icon-pencil"></span></div>');
    }
    var box = $('#'+job.id);
    box.css({left: dimensions.left, top: dimensions.top, height: dimensions.height, width: $('td#'+job.technician_id).outerWidth() - 4});
  }
};
function draw_timer(timer, job, units){
  if(timer.end_time){
    var difference = (parse_datetime_string(timer.end_time).getTime() - parse_datetime_string(timer.start_time).getTime())/1000/60;
  }else{
    var difference = (new Date().getTime() - parse_datetime_string(timer.start_time).getTime())/1000/60;
  }
  var dimensions = get_dimensions(units, timer.start_time, difference, job.technician_id);
  if($('div#'+timer.id).length == 0){
    $('body').append('<div class="timer" id="'+timer.id+'"><h2>RO# '+job.ro+'<span>'+job.lastname+'</span></h2><p>'+job.description+'</p></div>');
  }
  var box = $('#'+timer.id);
  box.css({left: dimensions.left, top: dimensions.top, height: dimensions.height, width: $('td#'+job.technician_id).outerWidth() - 4});
}
function get_dimensions(units, start_time, difference, technician_id){
  var date = $('body > table').attr('data-date');
  var day = Date.parse(date.split(' ')[1].replace('/', '-').replace('/', '-')+' '+date.split(' ')[0]);
  var start_time = parse_datetime_string(start_time);
  var start_minutes = (start_time.getTime() - day.getTime())/1000/60;
  var top = start_minutes*units.pixels + $('tr.time_08_00').offset().top;
  var height = difference*units.pixels;
  var left = $('td#'+technician_id).offset().left + 1;
  return {'top':top,'left':left,'height':height};
}
function calculate_units(){
  // calculate minute height
  var top    = $('table#schedule').offset().top;
  var bottom = $('tr.time_05_30 td').offset().top;
  var minute = (bottom - top)/600;
  // return these values
  return {'pixels':minute};
};
function get_date_class(datetime){
  var month = datetime.getMonth() + 1; if(month < 10){ month = '0' + month }else{ month += '' };
  var day   = datetime.getDate(); if(day < 10){ day = '0' + day }else{ day += '' };
  return 'date_'+month+'_'+day+'_'+datetime.getFullYear();
}
function parse_datetime_string(string){
  var time    = string.split('T')[1].split('-')[0].split(':');
  var hours   = time[0]; hours   = parseInt(hours, 10);   if(hours   < 10){ hours   = '0' + hours   }else{ hours   += '' };
  var minutes = time[1]; minutes = parseInt(minutes, 10); if(minutes < 10){ minutes = '0' + minutes }else{ minutes += '' };
  var seconds = time[2]; seconds = parseInt(seconds, 10); if(seconds < 10){ seconds = '0' + seconds }else{ seconds += '' };
  var date  = string.split('T')[0].split('-');
  var month = date[1];
  var day   = date[2];
  var year  = date[0];
  // return {'month':month,'day':day,'year':year,'hours':hours,'minutes':minutes,'seconds':seconds};
  return Date.parse(year+'-'+month+'-'+day+' '+hours+':'+minutes+':'+seconds)
}
function get_jobs(){
  $.getJSON('/jobs', function(data){
    draw_jobs(data);
    DATA = data;
  });
}
function draw_jobs(data){
  var units = calculate_units();
  $.each(data, function(){draw_job(this, units)});
}
function dialog(){
  dialog = $('#dialog').dialog({
    autoOpen: false
    , modal: true
    , width: 600
    , buttons:{ 
                "Save": function(){
                  $('#dialog form').ajaxSubmit({
                    success: function(){
                      get_jobs();
                      dialog.dialog("close");
                    }
                  });
                }
                , "Cancel": function(){dialog.dialog("close")}
              }
  });
}
function new_job_setup(){
  $('#schedule tbody td').live('click', function(){
    TIMECLASS = $(this).parent().attr('class');
    dialog.empty();
    dialog.dialog('option', 'title', 'New Job');
    dialog.load('/technicians/'+$(this).attr('data-tech-id')+'/jobs/new', function(){
      dialog.dialog("open");
    });
  });
}
function edit_job_setup(){
  $('div.job span.ui-icon-pencil').live("click", function(){
    dialog.empty();
    dialog.dialog('option', 'title', 'New Job');
    dialog.load('/jobs/'+$(this).parent().attr('id')+'/edit', function(){
      dialog.dialog("open");
    });
  });
};
// everything that gets initiated on load
$(function(){
  // pull all jobs
  get_jobs();
  // draw jobs
  $(window).resize(function(){
    draw_jobs(DATA);
  });
  // // setup my dialog box
  dialog();
  new_job_setup();
  edit_job_setup();
});