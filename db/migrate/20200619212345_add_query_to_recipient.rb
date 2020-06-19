class AddQueryToRecipient < ActiveRecord::Migration[6.0]
  def change
    add_column :recipients, :query_id, :int
  end
end
