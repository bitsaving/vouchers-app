module VouchersHelper
  #FIXME_AB: Why we need this method
  # it is neede for view portion
  def get_entered_data(field,position1)
    Rails.logger.debug "$$$$ #{field} ++  #{position1}"
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
end
