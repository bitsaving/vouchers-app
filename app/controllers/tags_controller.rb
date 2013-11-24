class TagsController < ApplicationController
  def index
    #FIXME_AB: You are finding all records and then just extracting name. How about using Tag.pluck(:name). Read about pluck if you don't know. Also see the difference in the sql query
  	#fixed
  	@tags = Tag.pluck( 'name')
    render :json => @tags
  end
end
