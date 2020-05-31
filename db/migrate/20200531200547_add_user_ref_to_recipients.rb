class AddUserRefToRecipients < ActiveRecord::Migration[6.0]
  def change
    add_reference :recipients, :user, null: false, foreign_key: true
  end
end
