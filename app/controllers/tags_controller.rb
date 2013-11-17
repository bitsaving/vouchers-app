class TagsController < ApplicationController
  def index
    #FIXME_AB: Why we are collecting all tags through vouchers, There is a better way?
    #fixed
  	@tags = Tag.all.collect{ |tag| tag.name  }
    render :json=> @tags
  end
end
