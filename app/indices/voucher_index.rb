ThinkingSphinx::Index.define :voucher, :with => :active_record,:delta=> true do
  indexes :date
  indexes debit_from.name , :as => :debited_account
  indexes credit_to.name, :as => :credited_account
  indexes transactions.amount
  indexes transactions.payment_type
  indexes transactions.payment_reference
  indexes transactions.transaction_type
  #indexes amount
  indexes (:id)
  #indexes payment_type
  #indexes payment_reference
  indexes workflow_state
  indexes from_date
  indexes to_date
  indexes assignee.email, :as => :assignee_email
  indexes [assignee.first_name, assignee.last_name ], :as => :assignee_name
  indexes [creator.first_name, creator.last_name], :as => :creator_name
  indexes creator.email, :as => :creator_email
  indexes [approved_by_user.first_name, approved_by_user.last_name], :as => :accepted_by_name
  indexes [accepted_by_user.first_name, accepted_by_user.last_name], :as => :approved_by_name
  indexes approved_by_user.email, :as => :approved_by_email
  indexes accepted_by_user.email, :as => :accepted_by_email
  indexes comments.description
  indexes attachments.bill_attachment_file_name
  indexes tags.name
  has created_at, updated_at
end
