class CreateAllTabels < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |user|
      user.string :full_name
      user.string :username
      user.string :password
      user.string :email
      user.datetime :birthday
      user.string :profile_picture_url
    end

    create_table :posts do |post|
      post.string :title
      post.string :content
      post.string :image_url
      post.string :video_url
      post.string :hashtags
      post.string :location
      post.string :studio
      post.string :style
      post.integer :user_id
    end

    create_table :tags do |tag|
      tag.string :name
    end

    create_table :posts_tags do |posts_tag|
      posts_tag.integer :post_id
      posts_tag.integer :tag_id
    end

  end
end