module VouchersHelper
  def get_entered_data(field,position,transaction)
    if !@voucher.new_record?
   	  if field == "debit"
	      @voucher.debit_from[position].name
	    else
	      @voucher.credit_to[position].name
	    end
	  elsif @voucher.errors.present?
      Rails.logger.debug "!!!! #{transaction.to_s}"
      Rails.logger.debug "@@@@@#{params["voucher"]["transactions_attributes"][transaction.to_s]["account_id"]}"
      Account.find(params["voucher"]["transactions_attributes"][transaction.to_s]["account_id"]).name
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
    Voucher.all.group_by(&:workflow_state)
  end

end
