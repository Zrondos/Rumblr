require 'sinatra'
require 'sinatra/flash'
require './models'
require 'sinatra/activerecord'
enable :sessions

@@user_id=nil
@@posts_to_show=[]


#Landing Page
get '/' do
    if session[:user_id]
        erb :all_posts, locals: {posts: Post.all }
    else
        erb :index 
    end
end

#Sign up
get '/sign_up' do
    erb :sign_up
end

post '/sign_up' do
    if User.find_by(username: params[:username])
        puts "Username already taken"
    elsif params[:password]!=params[:confirm_password]
        puts "Passwords do not match"
    else
        user = User.create(
            full_name: params[:full_name],
            username: params[:username],
            password: params[:password],
            email: params[:email],
            birthday: params[:birthday],
            profile_picture_url: params[:profile_picture_url],
        )
        session[:user_id]=user.id
        @@user_id=user.id
        redirect '/all_posts'
    end
end

#Sign In
get '/sign_in' do
    erb :sign_in
end

post '/sign_in' do 
    user = User.find_by(username: params[:username])
    puts params[:password] == user.password
    if user && user.password == params[:password]
        session[:user_id] = user.id
        @@user_id=user.id
        # flash[:info] = 'You have been signed in'
        redirect '/all_posts'
    else
        flash[:error] = 'Incorrect username and/or password'
        redirect '/sign_in'
    end
end

#Log out
get '/logout' do
    session[:user_id] = nil
    redirect '/'
end

#Settings
get '/settings' do
    if session[:user_id]
        erb :settings
    else 
        redirect '/sign_in'
    end
end

post '/settings' do
    user=User.find(@@user_id)
    if params[:password] == params[:confirm_password]
        user.password=params[:password]
        user.save  
    else
        puts "couldn't change password"
    end
    redirect '/settings'
end

post '/delete_account' do
    user=User.find(@@user_id)
    user.destroy
    session[:user_id] = nil
    redirect '/'
end

#Create posts and news feed
get '/all_posts' do
    if session[:user_id]
        erb :all_posts, locals: {posts: Post.all }
    else 
        redirect '/sign_in'
    end
end

post '/all_posts' do 
    post = Post.create(
        title: params[:title],
        content: params[:content],
        image_url: params[:image_url],
        video_url: params[:video_url],
        hashtags: params[:hashtags],
        location: params[:location],
        studio: params[:studio],
        style: params[:style],
        user_id: @@user_id
    )
    redirect '/all_posts'
end

get '/profile' do
    if session[:user_id]
        erb :profile
    else
        redirect '/sign_in'
    end
end

post '/create_post' do
    puts params[:hashtags]

    post = Post.create(
        title: params[:title],
        content: params[:content],
        image_url: params[:image_url],
        video_url: params[:video_url],
        hashtags: params[:hashtags],
        location: params[:location],
        studio: params[:studio],
        style: params[:style],
        user_id: @@user_id
    )
    tags = params[:hashtags].split(" ")
    for i in tags
        tag = Tag.find_or_create_by(name: i)
        Posts_tag.create(
            post_id: post.id,
            tag_id: tag.id
        )
    end
    redirect '/all_posts'
end
#Hashtags 

get '/search_by_hashtags' do
    if session[:user_id]
        erb :search_by_hashtags
    else
        redirect '/sign_in'
    end
end

post '/posts_by_hashtags' do
    
    hashtag_to_search_array = params[:hashtag_to_search].split(" ")
    for i in hashtag_to_search_array do
        tag_id=(Tag.find_by(name: i)).id
        posts_with_tag=Posts_tag.where(tag_id: tag_id).all
        for post in posts_with_tag do
            post_to_add=Post.find(post.post_id)
            @@posts_to_show.push(post_to_add)
        end
    end
    redirect '/posts_by_hashtags'
end    

post '/search_locations' do
    location=params[:location]
    posts=Post.where(location: location).all
    for post in posts do
        @@posts_to_show.push(post)
    end
    redirect '/posts_by_hashtags'
end

post '/search_studios' do
    studio=params[:studio]
    posts=Post.where(studio: studio).all
    for post in posts do
        @@posts_to_show.push(post)
    end
    redirect '/posts_by_hashtags'
end

post '/search_style' do
    style=params[:style]
    posts=Post.where(style: style).all
    for post in posts do
        @@posts_to_show.push(post)
    end
    redirect '/posts_by_hashtags'
end

get "/posts_by_hashtags" do
    erb :posts_by_hashtags
end

get "/gallery" do
    erb :gallery
end
