class RemoveNameFromRecipients < ActiveRecord::Migration[6.0]
  def change
    remove_column :recipients, :name, :string
  end
end
