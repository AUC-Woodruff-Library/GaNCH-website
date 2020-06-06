class AddAddressToRecipients < ActiveRecord::Migration[6.0]
  def change
    add_column :recipients, :address, :string
  end
end
