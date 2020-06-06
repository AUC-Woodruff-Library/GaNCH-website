class AddWikidataUrlToRecipients < ActiveRecord::Migration[6.0]
  def change
    add_column :recipients, :wikidata_url, :string
  end
end
