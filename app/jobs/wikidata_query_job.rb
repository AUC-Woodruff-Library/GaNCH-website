class WikidataQueryJob < ApplicationJob
  queue_as :wikidata

  def perform(query, user)
    url = Rails.configuration.wikidata_url
    throw if query.nil? || query.request.nil?
    throw ArgumentError if user.nil?
    sparql = SPARQL::Client.new("#{url}/sparql")
    logger.info("Sending query to Wikidata: #{query.request}")
    request = query.request
    response = sparql.query(request)
    logger.info("received: #{response.class}")
    if !response.nil?

      # convert response to JSON and save
      query.response = response.to_json
      logger.info("adding Wikidata response to query object #{query.id}")
      query.save!
    end
  end
end
