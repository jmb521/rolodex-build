require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    set :method_override, true
    enable :sessions
    set :session_secret, "my_secret"
  end

  get "/" do
    erb :welcome
  end

  get '/signup' do
    erb :signup
  end

  get '/login' do
    erb :login
  end

  post '/signup' do
    if params[:username] != "" || params[:email] != "" || params[:password] != ""
      if @user = User.find_by(:username => params[:username])
        redirect '/signup'
      else
        @user = User.create(:email => params[:email], :username => params[:username], :password => params[:password])
        session[:user_id] = @user.id
        redirect '/addresses'
      end
    else
      redirect '/signup'
    end
  end

  post '/login' do

    if params[:username] != "" || params[:password] != ""
      @user = User.find_by(:username => params[:username])

      if @user && @user.authenticate(params[:password])
        binding.pry
        session[:user_id] = @user.id
        redirect '/addresses'
      else
        redirect '/login'
      end
    else
      redirect '/login'

    end

  end

  get '/logout' do

    session.clear
    redirect '/'
  end


  helpers do
    def logged_in?
      !!current_user
    end

    def current_user

      User.find_by(:id => session[:user_id]) if session[:user_id]
    end

    def if_not_logged_in
      if !logged_in?
        redirect '/'
      end
    end

    def allowed_to_edit?(user)
      if user != current_user
        redirect '/addresses'
      else
        return true
      end
    end
  end

end
