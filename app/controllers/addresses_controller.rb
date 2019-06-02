class AddressesController < ApplicationController

  # GET: /addresses
  get "/addresses" do
    if_not_logged_in
    addresses = Address.all
    addr_hash={}
    addresses.each do |addr|
      addr_hash[addr.last_name.first.upcase] ||= []
      addr_hash[addr.last_name.first.upcase] << "<a href='/addresses/#{addr.id}'> #{addr.last_name},  #{addr.first_name}</a>"
    end
    @addresses = addr_hash

    erb :"/addresses/index.html"
  end

  # GET: /addresses/new
  get "/addresses/new" do
    if_not_logged_in
    erb :"/addresses/new.html"
  end

  # POST: /addresses
  post "/addresses" do
    if_not_logged_in
    if params[:address][:first_name] !="" || params[:address][:last_name] != "" || params[:address][:address1] != ""
      @address = Address.new(params[:address])
      @address.user_id = current_user.id
      if @address.save
        redirect "/addresses"
      end
    end
  end

  # GET: /addresses/5
  get "/addresses/:id" do
    if_not_logged_in
    @address = Address.find(params[:id])
    erb :"/addresses/show.html"
  end

  # GET: /addresses/5/edit
  get "/addresses/:id/edit" do
    if_not_logged_in
    @address = Address.find(params[:id])
    if allowed_to_edit?(@address.user)
      erb :"/addresses/edit.html"
    end
  end

  # PATCH: /addresses/5
  patch "/addresses/:id" do
    if_not_logged_in
    @address = Address.find(params[:id])
    if allowed_to_edit?(@address.user)
      @address.update(params[:address])
      redirect "/addresses/#{@address.id}"
    end
  end

  # DELETE: /addresses/5/delete
  delete "/addresses/:id/delete" do
    if_not_logged_in
    @address = Address.find(params[:id])
    if allowed_to_edit?(@address.user)
      @address.destroy
      redirect "/addresses"
    end
  end
end
