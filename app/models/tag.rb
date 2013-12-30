class Tag < ActiveRecord::Base

  def  self.get_autocomplete_suggestions
    @tags = Tag.pluck('name')
  end

end