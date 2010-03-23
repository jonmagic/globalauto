Factory.define :job do |f|
end

Factory.define :job1, :parent => :job do |f|
  f.ro_number "5551212"
  f.description "Fixing the radiator"
  f.technician_id 1
  f.completed nil
  f.clients_lastname "Hoyt"
end

Factory.define :job2, :parent => :job do |f|
  f.ro_number "123456"
  f.description "Replacing a hubcap"
  f.technician_id 1
  f.completed Time.zone.now - 24.hours
  f.clients_lastname "Hoyt"
end