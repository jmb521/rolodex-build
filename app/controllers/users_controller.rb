class UsersController < ApplicationController

#removed extra routes since we don't need to create/new or delete a user

  # GET: /users/5
  get "/users/:id" do
    if_not_logged_in
    @user = User.find(params[:id])
    erb :"/users/show.html"
  end

  # GET: /users/5/edit
  get "/users/:id/edit" do
    if_not_logged_in
    @user = User.find(params[:id])
    erb :"/users/edit.html"
  end

  # PATCH: /users/5
  patch "/users/:id" do
    if_not_logged_in
    @user = User.find(params[:id])
    if @user.authenticate(params[:current_password]) && params[:new_password1] == params[:new_password2]
      @user.password = params[:new_password1]
      if @user.save
        redirect "/users/#{@user.id}"
      else
        #we cannot save your password
        redirect "/users/#{@user.id}/edit"
      end
    else
      #put a flash message here about password being incorrect
    end
  end


end
