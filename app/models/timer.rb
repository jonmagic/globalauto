class Timer
  include MongoMapper::EmbeddedDocument
  
  key :start_time, Time
  key :end_time, Time
  
end
