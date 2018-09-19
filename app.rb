require 'sinatra'
require 'sinatra/flash'
require './models'
enable :sessions

@@user_id=nil
@@hashtag_string=nil

#Landing Page
get '/' do
    erb :index 
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
            profile_picture_url: params[:profile_picture_url]

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

#Account Settings
get '/account_settings' do
    erb :account_settings
end



post '/account_settings' do
    user=User.find(@@user_id)
    if params[:password] == params[:confirm_password]
        user.password=params[:password]
        user.save
        redirect '/account_settings'
    else
        puts "couldn't change password"
        redirect '/account_settings'
    end
end

get '/all_posts' do

    erb :all_posts, locals: {posts: Post.all }
end

get '/create_post' do
    erb :create_post
end

post '/create_post' do
    # puts session[:user_id].username
    # puts User.find(session[:user].id)
    post=Post.create(
        title: params[:title],
        content: params[:content],
        image_url: params[:image_url],
        video_url: params[:video_url],
        hashtags: params[:hashtags],
        user_id: @@user_id
    )    
    redirect '/users_posts'
end

get '/users_posts' do
    erb :users_posts
end

get '/search_by_hashtags' do
    erb :search_by_hashtags
end

post '/search_by_hashtags' do
    @@hashtag_string=params[:hashtag_to_search]
    redirect '/posts_by_hashtags'
end

get '/posts_by_hashtags' do
    erb :posts_by_hashtags
end




#Layout code


     