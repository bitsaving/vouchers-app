class AccountsController < ApplicationController
  before_action :authorize
	def index  
    if params[:term]
      @accounts = Account.find(:all,:conditions => ['name LIKE ?', "#{params[:term]}%"])
    else
     @accounts= Account.all
    end
    if @accounts.empty?
   	  Account.create(name:"#{params[:term]}" )
    end
    render :json => @accounts.collect {|x| {:label=>x.name, :value=>x.id}}.compact
  end
end

