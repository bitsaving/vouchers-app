class TagsController < ApplicationController
  def index
    #FIXME_AB: You are finding all records and then just extracting name. How about using Tag.pluck(:name). Read about pluck if you don't know. Also see the difference in the sql query
  	@tags = Tag.all.collect{ |tag| tag.name  }
    render :json => @tags
  end
end
