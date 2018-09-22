require 'sinatra'
require 'sinatra/flash'
require './models'
enable :sessions

@@user_id=nil

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
    if session[:user_id]
        erb :account_settings
    else 
        redirect '/'
    end
end

post '/account_settings' do
    user=User.find(@@user_id)
    puts params[:password]
    puts params[:confirm_password]
    if params[:password] == params[:confirm_password]
        user.password=params[:password]
        user.save  
    else
        puts "couldn't change password"
    end
    redirect '/account_settings'
end

post '/delete_account' do
    user=User.find(@@user_id)
    user.destroy
    session[:user_id] = nil
    redirect '/'
end

#Create posts and news feed
get '/all_posts' do
    output = ''
    output += erb :create_post
    output += erb :all_posts, locals: {posts: Post.all }
    output
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
    redirect '/all_posts'
end

get '/users_posts' do
    erb :users_posts
end

get '/create_trial_post' do
    erb :create_trial_post
end

post '/create_trial_post' do
    puts params[:hashtags]

    post = Post.create(
        title: params[:title],
        content: params[:content],
        hashtags: params[:hashtags],
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
    # redirect '/posts_by_hashtags'
end
#Hashtags 

get '/search_by_hashtags' do
    output = erb :search_by_hashtags
    params[:hashtag_to_search]
    if params[:posts_to_show]
        output += erb :posts_by_hashtags
    else
        output
    end
end

post '/posts_by_hashtags' do
    @posts_to_show=[]
    hashtag_to_search_array = params[:hashtag_to_search].split(" ")
    for i in hashtag_to_search_array do
        tag_id=(Tag.find_by(name: i)).id
        posts_with_tag=Posts_tag.where(tag_id: tag_id)
        posts_with_tag.each do |post_id|
            post=Post.find_by(id: post_id)
            @posts_to_show.push(post)
        end
    end
    erb :posts_by_hashtags

    # redirect "/search_by_hashtags?hashtag_to_search=#{params[:hashtag_to_search]}"

end     