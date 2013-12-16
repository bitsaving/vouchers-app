class UserSweeper < ActionController::Caching::Sweeper
  observe User
  def after_update(user)
    #if !(user.last_sign_in_at == DateTime.now || user.current_sign_in_at == DateTime.now)
  #if !(user.last_sign_in_at.changed? || user.current_sign_in_at.changed?)
    expire_cache(user)
  #end
  end
  def after_destroy(user)
    expire_cache(user)
  end 
  def expire_cache(user)
    # !(user.last_sign_in_at == DateTime.now || user.current_sign_in_at == DateTime.now)
   expire_action(:controller => 'admin/users', :action =>'show' , :id=> user)
  end
#end
end