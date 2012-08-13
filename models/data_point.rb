class DataPoint
  include DataMapper::Resource

  property :id,           Serial
  property :name,         String
  property :user_id,      Integer
  property :message,      Text
  property :wday,         String
  property :wday_numeric, Integer
  property :month,        Integer
  property :year,         Integer
  property :date,         String
  property :created_at,   DateTime
end
