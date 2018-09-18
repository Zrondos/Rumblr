require 'sinatra/activerecord'
require 'pg'

set :database, 'postgresql:rumblr_database'

class User < ActiveRecord::Base
end