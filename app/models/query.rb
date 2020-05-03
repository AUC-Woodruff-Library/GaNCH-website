class Query < ApplicationRecord
  require "sparql/client"
  extend ActiveModel::Callbacks

  validates :title, presence: true
  validates :request, presence: true

  define_model_callbacks :update
  before_save :get_query_response

  def headers
    hash = JSON.parse(self.response)
    headers = hash['head']['vars']
    logger.debug "Response hash vars: #{headers.inspect}"

    return headers
  end

  def body
    hash = JSON.parse(self.response)
    body = hash['results']['bindings']
    return body
  end

  private

  # send request to wikidata as a query
  def get_query_response
    throw :abort if self.request.nil?
    sparql = SPARQL::Client.new("https://query.wikidata.org/sparql")
    response = sparql.query(self.request)

    # sparql query will return nil on error
    self.response = response.to_json unless response.nil?

    logger.debug("Wikimedia query response: #{response}")

    return @query

  end
end
