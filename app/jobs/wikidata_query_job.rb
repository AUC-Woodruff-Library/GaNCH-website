class WikidataQueryJob < ApplicationJob
  queue_as :wikidata

  def perform(query)
    throw if query.nil? || query.request.nil?
    sparql = SPARQL::Client.new("https://query.wikidata.org/sparql")
    logger.info('Sending query to Wikidata: #{query.request}')
    request = query.request
    response = sparql.query(request)
    logger.debug("received: #{response.class}")
    if !response.nil?
      query.response = response.to_json
      logger.info("adding Wikidata response to query object #{query.id}")
      query.save!
    end
  end
end
