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
      url: window.location.href+'/jobs/',
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
    if(job.timers.length > 0 && TECHNICIAN){
      $('#'+job.id).remove();
      $.each(job.timers, function(){Timer.draw(this, job)});
    }else{
      // setup box dimensions
      if(job.flatrate_time){
        var difference = job.flatrate_time*60;
          difference = difference+job.intersection
      }else{
        var difference = 15;
      }
      if($('div#'+job.id).length == 0){
        $('body').append('<div class="job" id="'+job.id+'" data-ro="'+job.ro+'"></div>');
      }
      var box = $('#'+job.id);
      box.empty();
      var ref = '';
      if (job.ro === null && job.vehicle !== null){
        ref = job.vehicle;
      }else{
        var ref = 'RO# '+job.ro;
      }
      if (difference > 15) {
        box.append('<h2>'+job.lastname+'<span>'+ref+'</span><span class="ui-icon ui-icon-pencil"></span></h2>')
      }else{
        box.hover(function(){
          box.css('z-index', 100).css('min-height', 18);
          box.append('<h2>'+job.lastname+'<span>'+ref+'</span><span class="ui-icon ui-icon-pencil"></span></h2>')
        }, function(){
          box.empty();
          box.css('z-index', 10).css('min-height', 9);
        });
      }
      var dimensions = Dimensions.calculate(job.scheduled_at, difference, job.technician_id);
      if((dimensions.top + dimensions.height) > (BOTTOM + $('tr.time_05_30 td').height() + 4) && dimensions.top > 0){
        dimensions.height = (BOTTOM + $('tr.time_05_30 td').height() + 4) - dimensions.top;
      }else if(dimensions.top < 0 && (dimensions.top + 1435*pixelsPerMinute + dimensions.height) > (BOTTOM + $('tr.time_05_30 td').height() + 4)){
        dimensions.height = (dimensions.top + 1440*pixelsPerMinute + dimensions.height) - (BOTTOM + $('tr.time_05_30 td').height() + 8);
        if(dimensions.height < 40){
          dimensions.height = 40;
        };
        dimensions.top = $('tr.time_08_00 td').offset().top;
      }
      box.css({left: dimensions.left + 6, top: dimensions.top, height: dimensions.height, width: $('td#'+job.technician_id).outerWidth() - 16, backgroundColor: Job.state_color(job.state)});
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
    DIALOG.load('/jobs/'+job_id+'/edit', function(){
      if (DIALOG.find('table.job').attr('data-state')==='scheduled'){
        DIALOG.dialog('option', 'buttons', {
          "Save": function(){
            $('#dialog form').ajaxSubmit({
              success: function(){
                Jobs.getAndDraw();
                DIALOG.dialog("close");
              }
            });
          }
          , "Cancel": function(){DIALOG.dialog("close")},
          "No Show": function(){
            $.ajax({
              url: '/jobs/'+job_id+'/no_show',
              success: function(){
                Jobs.getAndDraw();
                DIALOG.dialog('close');
              }
            });
          },
          "Arrived": function(){
            $.ajax({
              url: '/jobs/'+job_id+'/arrived',
              success: function(){
                Jobs.getAndDraw();
                DIALOG.dialog('close');
              }
            });
          }
        });
      }else if(DIALOG.find('table.job').attr('data-state')==='here'){
        DIALOG.dialog('option', 'buttons', {
          "Save": function(){
            $('#dialog form').ajaxSubmit({
              success: function(){
                Jobs.getAndDraw();
                DIALOG.dialog("close");
              }
            });
          }
          , "Cancel": function(){DIALOG.dialog("close")},
          "Start": function(){
            $.ajax({
              url: '/jobs/'+job_id+'/toggle',
              success: function(){
                Jobs.getAndDraw();
                DIALOG.dialog('close');
              }
            });
          }
        });
      }else if(DIALOG.find('table.job').attr('data-state')==='no_show'){
        console.log('no show')
      }else if(DIALOG.find('table.job').attr('data-state')==='in_progress'){
        DIALOG.dialog('option', 'buttons', {
          "Save": function(){
            $('#dialog form').ajaxSubmit({
              success: function(){
                Jobs.getAndDraw();
                DIALOG.dialog("close");
              }
            });
          }
          , "Cancel": function(){DIALOG.dialog("close")},
          "Stop": function(){
            $.ajax({
              url: '/jobs/'+job_id+'/toggle',
              success: function(){
                Jobs.getAndDraw();
                DIALOG.dialog('close');
              }
            });
          },
          "Complete": function(){
            $.ajax({
              url: '/jobs/'+job_id+'/complete',
              success: function(){
                Jobs.getAndDraw();
                DIALOG.dialog('close');
              }
            });
          }
        });
      }else if(DIALOG.find('table.job').attr('data-state')==='pause'){
        DIALOG.dialog('option', 'buttons', {
          "Save": function(){
            $('#dialog form').ajaxSubmit({
              success: function(){
                Jobs.getAndDraw();
                DIALOG.dialog("close");
              }
            });
          }
          , "Cancel": function(){DIALOG.dialog("close")},
          "Start": function(){
            $.ajax({
              url: '/jobs/'+job_id+'/toggle',
              success: function(){
                Jobs.getAndDraw();
                DIALOG.dialog('close');
              }
            });
          },
          "Complete": function(){
            $.ajax({
              url: '/jobs/'+job_id+'/complete',
              success: function(){
                Jobs.getAndDraw();
                DIALOG.dialog('close');
              }
            });
          }
        });
      }else if(DIALOG.find('table.job').attr('data-state')==='complete'){
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
        
      }
      DIALOG.dialog("open");
    });
  },
  show: function(job_id){
    DIALOG.dialog('close');
    DIALOG.empty();
    DIALOG.dialog('option', 'buttons', {});
    DIALOG.load('/jobs/'+job_id, function(){
      if (DIALOG.find('table.job').attr('data-state')==='scheduled'){
        DIALOG.dialog('option', 'buttons', {
          "No Show": function(){
            $.ajax({
              url: '/jobs/'+job_id+'/no_show',
              success: function(){
                Jobs.getAndDraw();
                DIALOG.dialog('close');
              }
            });
          },
          "Arrived": function(){
            $.ajax({
              url: '/jobs/'+job_id+'/arrived',
              success: function(){
                Jobs.getAndDraw();
                DIALOG.dialog('close');
              }
            });
          }
        });
      }else if(DIALOG.find('table.job').attr('data-state')==='here'){
        DIALOG.dialog('option', 'buttons', {
          "Start": function(){
            $.ajax({
              url: '/jobs/'+job_id+'/toggle',
              success: function(){
                Jobs.getAndDraw();
                DIALOG.dialog('close');
              }
            });
          }
        });
      }else if(DIALOG.find('table.job').attr('data-state')==='no_show'){
        console.log('no show')
      }else if(DIALOG.find('table.job').attr('data-state')==='in_progress'){
        DIALOG.dialog('option', 'buttons', {
          "Stop": function(){
            $.ajax({
              url: '/jobs/'+job_id+'/toggle',
              success: function(){
                Jobs.getAndDraw();
                DIALOG.dialog('close');
              }
            });
          },
          "Complete": function(){
            $.ajax({
              url: '/jobs/'+job_id+'/complete',
              success: function(){
                Jobs.getAndDraw();
                DIALOG.dialog('close');
              }
            });
          }
        });
      }else if(DIALOG.find('table.job').attr('data-state')==='pause'){
        DIALOG.dialog('option', 'buttons', {
          "Start": function(){
            $.ajax({
              url: '/jobs/'+job_id+'/toggle',
              success: function(){
                Jobs.getAndDraw();
                DIALOG.dialog('close');
              }
            });
          },
          "Complete": function(){
            $.ajax({
              url: '/jobs/'+job_id+'/complete',
              success: function(){
                Jobs.getAndDraw();
                DIALOG.dialog('close');
              }
            });
          }
        });
      }else if(DIALOG.find('table.job').attr('data-state')==='complete'){
        console.log('complete')
      }
      DIALOG.dialog('open');
    });
  },
  state_color: function(state){
    if      (state==='scheduled'){
      return '#EEEEEE';
    }else if(state==='here'){
      return '#FFFF99';
    }else if(state==='no_show'){
      return '#800000';
    }else if(state==='in_progress'){
      return '#FFCC00';
    }else if(state==='pause'){
      return '#FF9999';
    }else if(state==='complete'){
      return '#969696';
    }
  }
};
var Timer = {
  draw: function(timer, job){
    var difference = 0;
    if(timer.end_time){
      difference = (Parse.dateTimeString(timer.end_time).getTime() - Parse.dateTimeString(timer.start_time).getTime())/1000/60;
    }else{
      difference = (new Date().getTime() - Parse.dateTimeString(timer.start_time).getTime())/1000/60;
    }
    var dimensions = Dimensions.calculate(timer.start_time, difference, job.technician_id);
    if((dimensions.top + dimensions.height) > (BOTTOM + $('tr.time_05_30 td').height() + 4) && dimensions.top > 0){
      dimensions.height = (BOTTOM + $('tr.time_05_30 td').height() + 4) - dimensions.top;
    }
    if($('div#'+timer.id).length == 0){
      $('body').append('<div class="timer" id="'+timer.id+'" data-job-id="'+job.id+'" data-ro="'+job.ro+'"></div>');
    }
    var box = $('#'+timer.id);
    if (difference > 15) {
      box.append('<h2>'+job.lastname+'<span>RO# '+job.ro+'</span><span class="ui-icon ui-icon-pencil"></span></h2><p>'+job.description+'</p>')
    }else{
      box.hover(function(){
        box.css('z-index', 100).css('min-height', 18);
        box.append('<h2>'+job.lastname+'<span>RO# '+job.ro+'</span><span class="ui-icon ui-icon-pencil"></span></h2><p>'+job.description+'</p>')
      }, function(){
        box.empty();
        box.css('z-index', 10).css('min-height', 9);
      });
    }
    box.css({left: dimensions.left + 6, top: dimensions.top, height: dimensions.height, width: $('td#'+job.technician_id).outerWidth() - 16, backgroundColor: Job.state_color(job.state)});
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
  
  // datepicker
  $('input#calendar').datepicker({
    buttonImage: '/images/icons/calendar.png',
    buttonImageOnly: true,
    constrainInput: true,
    dateFormat: 'mmdd20y',
    duration: 'fast',
    showButtonPanel: false,
    showOn: 'button',
    beforeShow: function(input, inst){
      setTimeout(function(){$('#ui-datepicker-div').css('z-index', 9999)}, 100);
    },
    onSelect: function(date, inst){
      document.location.href = date;
    }
  });
  
  // load notes for this day
  $('#note').load('/notes/'+$('#cal_header').attr('data-date'), function(){
    $('#note textarea').typeWatch({
      callback: function(){
        $('#note form').ajaxSubmit();
      },
      wait: 1000,
      highlight: true,
      captureLength: 3
    });
  });
  
  // set whether this is a technician or admin
  if ($('table#schedule').attr('data-view-type') == 'manager') {
    MANAGER = true;
    TECHNICIAN = false;
  } else if ($('table#schedule').attr('data-view-type') == 'technician') {
    MANAGER = false;
    TECHNICIAN = true;
  }
  
  // figure out pixels/minute
  pixelsPerMinute = Dimensions.pixelsPerMinute();
  
  // get & draw the jobs
  $(window).resize(function(){
    UNITS = Dimensions.pixelsPerMinute();
    Jobs.getAndDraw();
  });
  
  // setup the pull loop
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
  
  // new job
  $('#schedule tbody td').live('click', function(){
    TIMECLASS = $(this).parent().attr('data-time');
    Job.compose($(this).attr('data-tech-id'));
  });
  
  // edit job
  $('div.job h2').live("click", function(){
    DIALOG.dialog('option', 'title', 'RO# '+$(this).parent().attr('data-ro'));
    Job.edit($(this).parent().attr('id'));
    return false;
  });
  
  // edit job via timer
  $('div.timer h2 span.ui-icon').live("click", function(){
    DIALOG.dialog('option', 'title', 'RO# '+$(this).parent().attr('data-ro'));
    Job.edit($(this).parent().parent().attr('data-job-id'));
    return false;
  });
  
  // show job
  $('div.job p').live("click", function(){
    DIALOG.dialog('option', 'title', 'RO# '+$(this).parent().attr('data-ro'));
    Job.show($(this).parent().attr('id'));
  });
  $('div.timer').live("click", function(){
    DIALOG.dialog('option', 'title', 'RO# '+$(this).attr('data-ro'));
    Job.show($(this).attr('data-job-id'));
  });

});