require "rubygems"
require "sinatra"
require "data_mapper"

DataMapper.setup(:default, "sqlite://#{Dir.pwd}/db/database.db")

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/models/*.rb'].each {|file| require file }

DataMapper.finalize
DataMapper.auto_upgrade!

get '/' do
  @report = Report.new
  erb :index
end

get '/:id' do
  @report = Report.new
  erb :user
end
