# mongomapper connection
MongoMapper.connection = Mongo::Connection.new('127.0.0.1', 27017) # :logger => Rails.logger,
MongoMapper.database = "globalauto-#{RAILS_ENV}"