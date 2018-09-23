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
            profile_picture_url: params[:profile_picture_url],
            résumé_url: params[:upload]
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
    
    posts_to_show=[]
    puts params[:hashtag_to_search].class
    hashtag_to_search_array = params[:hashtag_to_search].split(" ")
    puts hashtag_to_search_array[0]
    puts 
    puts (hashtag_to_search_array).class
    puts "Hashtag_to_search_array !!!!!!!!!!!!" 
    puts hashtag_to_search_array.to_s
    for i in hashtag_to_search_array do
        tag_id=(Tag.find_by(name: i)).id
        puts "tag_id !!!!!!!!!!!!!!!!!!!!!!!!!!"
        puts tag_id
        posts_with_tag=Posts_tag.where(tag_id: tag_id)
        for post in posts_with_tag do
            post_to_add=Post.where(id: post.post_id)
            puts "!!!!!!!!!!!!!! post_to_add"
            puts post_to_add
            posts_to_show.push(post_to_add)
        end
        puts "posts_with_tag!!!!!!!!!!!!!!!!!!!!"
        puts posts_with_tag

        puts "posts_to_show full array !!!!!!!!!!!!!"
        puts posts_to_show
    end
    redirect '/posts_by_hashtags'
end     

get "/posts_by_hashtags" do
    erb :posts_by_hashtags
end

# <% for post in posts_to_show %>
#                 <ul>
#                     <li>
#                         Title: <%= post.title %><br />
#                         Content: <%= post.content %><br />
#                         Hashtag: <%= post.hashtags%>
#                         Image: <img src=<%= post.image_url %>><br />
#                         # Video: <iframe src=<%= post.video_url %>>
#                         # width="560" height="315" frameborder="0" 
#                         # allowfullscreen>
#                         # </iframe><br />
#                         <hr>
#                     </li>
#                 </ul>
#             <% end %>
#     <% end %>