module JobsHelper
  def scheduled_for_helper(job)
    string = ''
    string << "<select id='job_scheduled_at_4i' name='job[scheduled_at(4i)]'>"
    [['08', '8'], ['09', '9'], ['10', '10'], ['11', '11'], ['12', '12'], 
     ['01', '1'], ['02', '2'], ['03', '3'], ['04', '4'], ['05', '5']].each do |hour|
      selected = @job.scheduled_at && @job.scheduled_at.strftime('%H') == hour[0] ? " selected='selected'" : ""
      string << "<option value='#{hour[0]}'#{selected}>#{hour[1]}</option>"
    end  
    string << "</select>:<select id='job_scheduled_at_5i' name='job[scheduled_at(5i)]'>"
    ['00', '15', '30', '45'].each do |minute|
      selected = @job.scheduled_at && @job.scheduled_at.strftime('%M') == minute ? " selected='selected'" : ""
      string << "<option value='#{minute}'#{selected}>#{minute}</option>"      
    end
    string << "</select> <select id='job_scheduled_at_2i' name='job[scheduled_at(2i)]'>"
    [['January', '01'], ['February', '02'], ['March', '03'], ['April', '04'], ['May', '05'], ['June', '06'], 
     ['July', '07'], ['August', '08'], ['September', '09'], ['October', '10'], ['November', '11'], ['December', '12']].each do |month|
      selected = @job.scheduled_at && @job.scheduled_at.strftime('%m') == month[1] ? " selected='selected'" : ""
      string << "<option value='#{month[1]}'#{selected}>#{month[0]}</option>"      
    end
    string << "</select> <select id='job_scheduled_at_3i' name='job[scheduled_at(3i)]'>"
    [['01', '1'], ['02', '2'], ['03', '3'], ['04', '4'], ['05', '5'], ['06', '6'], ['07', '7'], ['08', '8'], ['09', '9'], ['10', '10'],
     ['11', '11'], ['12', '12'], ['13', '13'], ['14', '14'], ['15', '15'], ['16', '16'], ['17', '17'], ['18', '18'], ['19', '19'], ['20', '20'], 
     ['21', '21'], ['22', '22'], ['23', '23'], ['24', '24'], ['25', '25'], ['26', '26'], ['27', '27'], ['28', '28'], ['29', '29'], ['30', '30'], 
     ['31', '31']].each do |day|
      selected = @job.scheduled_at && @job.scheduled_at.strftime('%d') == day[0] ? " selected='selected'" : ""
      string << "<option value='#{day[0]}'#{selected}>#{day[1]}</option>"
    end
    string << "</select> <select id='job_scheduled_at_1i' name='job[scheduled_at(1i)]'>"
    ['2010', '2011', '2012', '2013', '2014', '2015', '2016'].each do |year|
      selected = @job.scheduled_at && @job.scheduled_at.strftime('%Y') == year ? " selected='selected'" : ""
      string << "<option value='#{year}'#{selected}>#{year}</option>"
    end
    string << "</select>"
    return string
  end
end
