module ApplicationHelper
	def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to("#{name}", '#', :onclick=> "remove_fields(this); return false")
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

  def format_date(date)
    date ? date.strftime('%d %b %Y') : nil
  end

  def get_pending_vouchers(account_id)
    @vouchers = Voucher.where(workflow_state: 'pending').where(["account_debited IN (?) OR account_credited IN (?)", account_id,account_id]).order('updated_at desc').page(params[:page]).per(10)
 end

  def get_pending_of_users(user_id)
    @vouchers = Voucher.where(workflow_state:'pending').where(creator_id: user_id).order('updated_at desc').page(params[:page]).per(10)
  end

  def getAccount(id)
    @account = Account.find(id)
  end
  
  def getUserNotifications
    notifications = PublicActivity::Activity.where('owner_id = ? and visited = false', current_user.id).order('id desc').count
    if notifications > 0
      notifications
    else
     ""
    end 
  end
  
end
