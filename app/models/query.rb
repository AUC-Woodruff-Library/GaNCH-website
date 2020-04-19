class Query < ApplicationRecord
  require "sparql/client"
  extend ActiveModel::Callbacks

  validates :title, presence: true
  validates :request, presence: true

  define_model_callbacks :update
  before_save :get_query_response

  private

  # send request to wikidata as a query
  def get_query_response
    throw :abort if self.request.nil?
    sparql = SPARQL::Client.new("https://query.wikidata.org/sparql")
    response = sparql.query(self.request)

    # sparql query will return nil on error
    self.response = response unless response.nil?

    logger.debug("Wikimedia query response: #{response}")

    return @query

  end
end
