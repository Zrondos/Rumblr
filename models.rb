require 'sinatra/activerecord'
require 'pg'

configure :development do
    set :database, 'postgresql:rumblr_database'
end

configure :production do
    set :database, ENV["DATABASE_URL"]
  end

class User < ActiveRecord::Base
    has_many :posts, dependent: :destroy
end

class Post < ActiveRecord::Base
    belongs_to :user
    has_many :posts_tags
    has_many :tags, through: :posts_tags
end

class Tag < ActiveRecord::Base
    has_many :posts_tags
    has_many :posts, through: :posts_tags
end

class Posts_tag < ActiveRecord::Base
    belongs_to :tag
    belongs_to :post
end


