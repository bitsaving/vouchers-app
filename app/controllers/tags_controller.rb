class TagsController < ApplicationController
  def index
  	@tags = Voucher.all.collect do |v|
       v.tag_list
    end
    @tags = @tags.flatten
    render :json=> @tags
  end
end
