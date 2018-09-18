require 'sinatra'
require 'sinatra/flash'
require './models'
enable :sessions

get '/' do
    erb :index
end

get '/sign_up' do
    erb :sign_up
end

post '/sign_up' do
    user = User.create(
        username: params[:username],
        password: params[:password]
    )
    session[:user_id]=user.id
end

get 'sign_in' do
    erb :sign_in
end

post 'sign_in' do 
    user=User.create(
        username: params[:username],
        password: params[:password]
    )
