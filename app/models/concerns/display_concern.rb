module DisplayConcern

  extend ActiveSupport::Concern

  def strip_blanks
    #FIXME_AB: We can avoid many self here. More over I think we can define their individual method in respective models like display_name.
  	if self.is_a? User
  		self.first_name = self.first_name.squish
  		self.last_name = self.last_name.squish
  	end
  	if self.is_a? Account
  		self.name = self.name.squish
  	end
  end
end
