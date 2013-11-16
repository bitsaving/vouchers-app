class TagsController < ApplicationController
  def index
    #FIXME_AB: Why we are collecting all tags through vouchers, There is a better way?
  	@tags = Voucher.all.collect do |v|
       v.tag_list
    end
    @tags = @tags.flatten
    render :json=> @tags
  end
end
