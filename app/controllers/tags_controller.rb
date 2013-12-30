class TagsController < ApplicationController

  def index
  	render :json => Tag.get_autocomplete_suggestions
  end

end
