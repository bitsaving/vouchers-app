module VouchersHelper
  #FIXME_AB: Why we need this method
  # it is neede for view portion
  def get_entered_data(field)
    if !@voucher.new_record?
   	  if field == "debit"
	    @voucher.debit_from.name
	  else
	    @voucher.credit_to.name
	  end
	end
  end

  def setDate()
    if @voucher.new_record?
      Date.today.to_s(:normal_format)
    else
      @voucher.date
    end
  end
end
