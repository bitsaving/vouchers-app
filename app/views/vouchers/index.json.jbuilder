json.array!(@vouchers) do |voucher|
  json.extract! voucher, 
  json.url voucher_url(voucher, format: :json)
end
