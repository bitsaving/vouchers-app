PublicActivity::Activity.class_eval do
  def seen!
   self.seen = true
   self.save!
  end
end