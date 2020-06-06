class AddLocationToRecipients < ActiveRecord::Migration[6.0]
  def change
    add_column :recipients, :location, :string
  end
end
