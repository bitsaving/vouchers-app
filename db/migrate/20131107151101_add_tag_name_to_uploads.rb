class AddTagNameToUploads < ActiveRecord::Migration
  def change
  	add_column :uploads ,:tagname,:string
  end
end
