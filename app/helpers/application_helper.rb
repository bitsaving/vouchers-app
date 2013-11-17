module ApplicationHelper
	
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to("#{name}", '#', :onclick => "remove_fields(this); return false")
  end
  
  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to("#{name}","#",:onclick=> "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\") ;return false")
  end
 
  def account_options
    Account.pluck( 'name', 'id' )
  end
  
  def user_options
    User.where.not(id:  current_user.id).pluck( 'first_name ', 'id' )
  end

  #FIXME_AB: I am not sure why we need this. A better way could be to extend time formats. We had a session by Pramod once
  #fixed
  def get_new_by_date(to,from)
    @vouchers = Voucher.where(workflow_state:'new').where('date between (?) and (?)',to,from).order('updated_at desc').page(params[:page]).per(10)
  end
  #FIXME_AB: I think we don't need this method. if we add a scope called pending in voucher which return pending vouchers then we can get same thing by account.vouchers.pending. No?
  #fixed

  
  #FIXME_AB: Why you are using two types of method naming conventions. One with underscore other with camelCase
  def getAccount(id)
    @account = Account.find(id)
  end
  
  #FIXME_AB: Better suites to User model
  def getUserNotifications
    notifications = PublicActivity::Activity.where('owner_id = ? and visited = false', current_user.id).order('id desc').count
    if notifications > 0
      notifications
    else
     ""
    end 
  end
  
end
