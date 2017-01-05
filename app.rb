require 'sinatra'
require 'sinatra/activerecord'
require 'pry'
require_relative 'config/application'
require_relative 'app/models/user'
require_relative 'app/models/meetup'

set :bind, '0.0.0.0'  # bind to all interfaces

helpers do
  def current_user
    if @current_user.nil? && session[:user_id]
      @current_user = User.find_by(id: session[:user_id])
      session[:user_id] = nil unless @current_user
    end
    @current_user
  end
end

get '/' do
  redirect '/meetups'
end

get '/auth/github/callback' do
  user = User.find_or_create_from_omniauth(env['omniauth.auth'])
  session[:user_id] = user.id
  flash[:notice] = "You're now signed in as #{user.username}!"

  redirect '/'
end

get '/sign_out' do
  session[:user_id] = nil
  flash[:notice] = "You have been signed out."

  redirect '/'
end

get '/meetups' do
  @meetups = Meetup.all.order('meetup_name')

  erb :'meetups/index'
end

get '/meetups/new' do
  erb :'meetups/new'
end

post '/meetups/new' do

  if params[:meetup_name] == '' || params[:meetup_description] == '' || params[:meetup_location] == ''
    @error_msg = 'Please fill in ALL fields'
    @name_field = params[:meetup_name]
    @description_field = params[:meetup_description]
    @location_field = params[:meetup_location]
    erb :'meetups/new'
  elsif session[:user_id].nil?
    @error_msg = 'You must be signed in to create a meetup'
    erb :'meetups/new'
  else
    binding.pry
    Meetup.create(creator_id: session[:user_id], meetup_name: params[:meetup_name], description: params[:meetup_description], location: params[:meetup_location])
    redirect '/meetups'
  end
end

get '/meetups/:id' do
  @meetup = Meetup.find(params[:id])
  @attendees = @meetup.users

  unless session[:user_id].nil?
    user = User.find(session[:user_id])
  end

  @hide_button = @attendees.include?(user)

  erb :'meetups/show'
end

post '/meetups/join/:id' do
  @meetup = Meetup.find(params[:id])
  @attendees = @meetup.users

  unless session[:user_id].nil?
    user = User.find(session[:user_id])
  end

  if session[:user_id].nil?
    @error_msg = "You need to log in first"
    erb :'meetups/show'
  elsif @meetup.users.include?(user)
    @error_msg = "You have already joined this meetup"
    erb :'meetups/show'
  else
    @meetup.users << user
    redirect "meetups/#{params[:id]}"
  end

end
