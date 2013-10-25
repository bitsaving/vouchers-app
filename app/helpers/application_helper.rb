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
    User.pluck( 'first_name ', 'id' )
  end
   def format_date(date)
    date ? date.strftime('%a %b %d') : nil
  end
  def getAssignedUser
    Voucher.find(:all,:conditions=> "assigned_to_id = #{current_user.id} and workflow_state != 'accepted'").count
  end
end
