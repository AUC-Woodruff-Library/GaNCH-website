class RemoveTitleFromRecipients < ActiveRecord::Migration[6.0]
  def change
    remove_column :recipients, :title, :string
  end
end
