module ApplicationHelper
	
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to("#{name}", '#', :onclick => "remove_fields(this); return false")
  end
  
  def link_to_add_fields(name, f, association, counter)
    new_object = f.object.class.reflect_on_association(association).klass.new
    array = name.split(" ")
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      @count = @count + 1
      render(association.to_s.singularize + "_fields", :f => builder, :count => @count , :@transaction_type => array[2])
    
    end
    link_to("#{name}", "#", :onclick=> "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\") ;return false")
  end
 
  # def account_options
  #   Account.pluck( 'name', 'id' )
  # end
  
  def user_options(voucher)
    User.where.not(id: [current_user.id, voucher] ).order('first_name').pluck( 'first_name ', 'id' )
  end

  def get_by_date(state,from, to, name,type, tag)
    @voucherss = Voucher.between_dates(from, to)
    @voucherss  = @voucherss.by_account(name) if name.present?
    @voucherss = @voucherss.by_transaction_type(type) if type.present?
    @voucherss = @voucherss.tagged_with(tag) if tag.present?
    @voucherss = @voucherss.send(state) if state.present?
    @voucherss = @voucherss.created_by(current_user.id) if state == "drafted"
    @voucherss
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
    Voucher.transaction_account(id)
  end
  
  def getaccount(id)
    @account = Account.find_by(id: id)
  end

  def get_drafted_vouchers
    current_user.vouchers.drafted
  end
  
  def populate_dropdown
    time = Time.new
    i = 0
    years = []
    year = time.year
    j =-1
    while(i < 10)
      date = []
      date << Date.new.change(day: 31, month: 3, year: year - i).year.to_s  + "-"  + Date.new.change(day: 1, month: 4, year: year - j).year.to_s
      date << Date.new.change(day: 31, month: 3, year: year - i).to_s  + "->"  + Date.new.change(day: 1, month: 4, year: year - j).to_s
      years << date
      j = j + 1
      i = i+1
    end
    years
  end
    
end
