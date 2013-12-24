module ApplicationHelper
	
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to("#{name}", '#', :onclick => "remove_fields(this); return false")
  end
  
  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    array = name.split(" ")
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder, locals: { :@account_type => array[1]})
    end

    link_to("#{name}", "#", :onclick=> "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\") ;return false")
  end
 
  def account_options
    Account.pluck( 'name', 'id' )
  end
  
  def user_options
    User.where.not(id: current_user.id).order('first_name').pluck( 'first_name ', 'id' )
  end

  def get_by_date(state,to,from,name,type)
    @vouchers = Voucher.where(workflow_state:state).where('date between (?) and (?)', to, from)
    @vouchers  = @vouchers.includes(:transactions).where(:transactions => {:account_id => name}) if !name.blank?
    @vouchers = @vouchers.includes(:transactions).where(:transactions => {:account_type => type }) if !type.blank?
    @vouchers
  end

  def nav_link(link_text, link_path)
    controller_name  = request.path.split('/')
    if controller_name[1].blank?
      controller_name[1] = "home"
    elsif controller_name[1] == "admin"
      controller_name[1] = "users"
    end
    class_name = controller_name[1] == link_text.downcase ? 'highlight' : ""
    content_tag(:li, :class => class_name) do
      link_to link_text, link_path , 'data-no-turbolink'=> true
    end
  end
  
  def get_all_vouchers(id)
    Voucher.includes(:transactions).where(:transactions => {:account_id => params[:account_id]})
  end
  
   def getaccount(id)
    @account = Account.find_by(id: id)
  end
  
  
  
end
