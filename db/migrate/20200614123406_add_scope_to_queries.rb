class AddScopeToQueries < ActiveRecord::Migration[6.0]
  def change
    add_column :queries, :scope, :integer
  end
end
