module VouchersHelper
  def get_entered_data(field,position1)
    if !@voucher.new_record?
   	  if field == "debit"
	      @voucher.debit_from[position1].name
	    else
	      @voucher.credit_to[position1].name
	    end
	  end
  end

  def set_date(type)
    if !@voucher.new_record?
      if @voucher.to_date.present?
        if type == 'from'
          @voucher.from_date.to_s(:normal_format)
        else
          @voucher.to_date.presence.to_s(:normal_format)
        end
      end
    end
  end

  def get_vouchers_count
    @vouchers =Voucher.between_dates(session[:start_date], session[:end_date])
    @vouchers.all.group_by(&:workflow_state)
  end

end
