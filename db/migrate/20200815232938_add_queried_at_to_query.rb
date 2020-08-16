class AddQueriedAtToQuery < ActiveRecord::Migration[6.0]
  def change
    add_column :queries, :queried_at, :datetime
  end
end
