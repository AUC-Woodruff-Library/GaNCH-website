class AddUserIdToQueries < ActiveRecord::Migration[6.0]
  def change
    add_column :queries, :user_id, :integer
  end
end
