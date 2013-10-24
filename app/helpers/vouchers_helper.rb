module VouchersHelper
	def get_entered_data(field)
		if !@voucher.new_record?
			if field == "debit"
		      @voucher.debit_from.name
		    else
			  @voucher.credit_to.name
		    end
	    end
    end
end
