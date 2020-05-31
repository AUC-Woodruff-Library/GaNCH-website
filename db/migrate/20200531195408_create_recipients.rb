class CreateRecipients < ActiveRecord::Migration[6.0]
  def change
    create_table :recipients do |t|
      t.string :name
      t.string :title
      t.string :email
      t.string :phone
      t.string :organization

      t.timestamps
    end
  end
end
