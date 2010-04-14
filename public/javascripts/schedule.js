var Parse = {
  dateTimeString: function(string){
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
}
var Jobs = {
  getAndDraw: function(){
    $.ajax({
      url: window.location.href+'/jobs',
      dataType: 'json',
      success: function(data, result){
        $.each(data, function(i, job){
          Job.draw(job);
        });
      }
    });
  }
};
var Job = {
  draw: function(job){
    if(job.timers.length > 0){
      $.each(job.timers, function(){Timer.draw(this, job)});
    }else{
      // setup box dimensions
      if(job.flatrate_time){
        var difference = job.flatrate_time*60;
      }else{
        var difference = 60;
      }
      if($('div#'+job.id).length == 0){
        $('body').append('<div class="job" id="'+job.id+'" data-ro="'+job.ro+'"><h2>RO# '+job.ro+'<span>'+job.lastname+'</span><span class="ui-icon ui-icon-pencil"></span></h2><p>'+job.description+'</p></div>');
      }
      var box = $('#'+job.id);
      var dimensions = Dimensions.calculate(job.scheduled_at, difference, job.technician_id);
      if((dimensions.top + dimensions.height) > (BOTTOM + $('tr.time_05_30 td').height() + 4) && dimensions.top > 0){
        dimensions.height = (BOTTOM + $('tr.time_05_30 td').height() + 4) - dimensions.top;
      }else if(dimensions.top < 0 && (dimensions.top + 1435*pixelsPerMinute + dimensions.height) > (BOTTOM + $('tr.time_05_30 td').height() + 4)){
        dimensions.height = (dimensions.top + 1440*pixelsPerMinute + dimensions.height) - (BOTTOM + $('tr.time_05_30 td').height() + 8);
        console.log(dimensions.height);
        if(dimensions.height < 40){
          dimensions.height = 40;
        };
        dimensions.top = $('tr.time_08_00 td').offset().top;
      }
      // setup box color
      // if(job.status=="")
      box.css({left: dimensions.left, top: dimensions.top, height: dimensions.height, width: $('td#'+job.technician_id).outerWidth() - 4});
    };
  },
  compose: function(tech_id){
    DIALOG.dialog('close');
    DIALOG.empty();
    DIALOG.dialog('option', 'title', 'New Job');
    DIALOG.dialog('option', 'buttons', {
              "Save": function(){
                $('#dialog form').ajaxSubmit({
                  success: function(){
                    Jobs.getAndDraw();
                    DIALOG.dialog("close");
                  }
                });
              }
              , "Cancel": function(){DIALOG.dialog("close")}
            });
    DIALOG.load('/technicians/'+tech_id+'/jobs/new', function(){
      DIALOG.dialog("open");
    });
  },
  edit: function(job_id){
    DIALOG.dialog('close');
    DIALOG.empty();
    DIALOG.dialog('option', 'buttons', {
              "Save": function(){
                $('#dialog form').ajaxSubmit({
                  success: function(){
                    Jobs.getAndDraw();
                    DIALOG.dialog("close");
                  }
                });
              }
              , "Cancel": function(){DIALOG.dialog("close")}
            });
    DIALOG.load('/jobs/'+job_id+'/edit', function(){
      DIALOG.dialog("open");
    });
  },
  show: function(job_id){
    DIALOG.dialog('close');
    DIALOG.empty();
    DIALOG.dialog('option', 'buttons', {});
    DIALOG.load('/jobs/'+job_id, function(){
      DIALOG.dialog('open');
    });
  }
};
var Timer = {
  draw: function(timer, job){
    if(timer.end_time){
      var difference = (Parse.dateTimeString(timer.end_time).getTime() - Parse.dateTimeString(timer.start_time).getTime())/1000/60;
    }else{
      var difference = (new Date().getTime() - Parse.dateTimeString(timer.start_time).getTime())/1000/60;
    }
    var dimensions = Dimensions.calculate(timer.start_time, difference, job.technician_id);
    if($('div#'+timer.id).length == 0){
      $('body').append('<div class="timer" id="'+timer.id+'" data-ro="'+job.ro+'"><h2>RO# '+job.ro+'<span>'+job.lastname+'</span></h2><p>'+job.description+'</p></div>');
    }
    var box = $('#'+timer.id);
    box.css({left: dimensions.left, top: dimensions.top, height: dimensions.height, width: $('td#'+job.technician_id).outerWidth() - 4});
  }
};
var Dimensions = {
  pixelsPerMinute: function(){
    // calculate minute height
    Dimensions.top();
    Dimensions.bottom();
    var pixelsPerMinute = (BOTTOM - TOP)/600;
    // return these values
    return pixelsPerMinute
  },
  top: function(){
    TOP = $('table#schedule').offset().top;
  },
  bottom: function(){
    BOTTOM = $('tr.time_05_30 td').offset().top;
  },
  calculate: function(start_time, difference, technician_id){
    var date = $('body > table').attr('data-date');
    var day = Date.parse(date.split(' ')[1].replace('/', '-').replace('/', '-')+' '+date.split(' ')[0]);
    var start_time = Parse.dateTimeString(start_time);
    var start_minutes = (start_time.getTime() - day.getTime())/1000/60;
    var top = start_minutes*pixelsPerMinute + $('tr.time_08_00').offset().top;
    var height = difference*pixelsPerMinute;
    var left = $('td#'+technician_id).offset().left + 1;
    return {'top':top,'left':left,'height':height};
  }
};
// everything that gets initiated on load
$(function(){
  // figure out pixels/minute
  pixelsPerMinute = Dimensions.pixelsPerMinute();
  // get & draw the jobs
  $(window).resize(function(){
    UNITS = Dimensions.pixelsPerMinute();
    Jobs.getAndDraw()
  });
  function loop(){
    Jobs.getAndDraw();
    setTimeout(function(){loop()}, 30000)
  }
  loop();
  // setup my dialog box
  DIALOG = $('#dialog').dialog({
    autoOpen: false
    , modal: true
    , width: 600
  });
  // new job setup
  $('#schedule tbody td').live('click', function(){
    TIMECLASS = $(this).parent().attr('class');
    Job.compose($(this).attr('data-tech-id'));
  });
  // edit job setup
  $('div.job h2').live("click", function(){
    DIALOG.dialog('option', 'title', 'RO# '+$(this).parent().attr('data-ro'));
    Job.edit($(this).parent().attr('id'));
  });
  // show job setup
  $('div.job p').live("click", function(){
    DIALOG.dialog('option', 'title', 'RO# '+$(this).parent().attr('data-ro'));
    Job.show($(this).parent().attr('id'));
  });
});