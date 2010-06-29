class Note
  include MongoMapper::Document
  
  key :text, String
  key :date, String, :required => true
  
end