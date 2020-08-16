class Recipient < ApplicationRecord
  validates :organization, presence: true
  validates :user_id, presence: true
  validates :email, presence: true

  belongs_to :query
  belongs_to :user

  # iterate over rows in wikidata reponse and create recipients from email fields
  def self.scrape(query)
    json = JSON.parse(query.response)
    logger.info("looking for recipients for query: #{query.id}")
    return unless json["results"]["bindings"]

    # clear out old recipient data
    Recipient.destroy_by(query_id: query.id)

    bindings = json["results"]["bindings"]
    bindings.each do |entry|
      next unless entry.has_key? "e_mail_address"
      logger.info("Creating recipient for #{entry}")
      recipient = Recipient.new
      recipient.email = RecipientsController.helpers.get_email(entry["e_mail_address"])
      recipient.phone = RecipientsController.helpers.get_phone_number(entry["phone_number"]) if entry.has_key? "phone_number"
      recipient.organization = RecipientsController.helpers.get_label(entry)
      recipient.query = query
      recipient.user = query.user
      recipient.address = entry['street_address'] && entry['street_address']['value']
      recipient.wikidata_url = entry['organization'] && entry['organization']['value']
      recipient.location = entry['coordinate_location'] && entry['coordinate_location']['value']
      recipient.save!
    end
  end

end
