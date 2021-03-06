class Query < ApplicationRecord
  require "sparql/client"
  extend ActiveModel::Callbacks

  belongs_to :user

  validates :title, presence: true
  validates_uniqueness_of :title, :case_sensitive => false
  validates :scope, presence: true
  validates :request, presence: true

  before_save :sanitize_request_string

  define_model_callbacks :update
  enum scope: [:state, :region, :county]

  def headers
    return nil if self.response == '' or self.response.nil?
    hash = JSON.parse(self.response)
    headers = hash['head']['vars']
    logger.debug "Response hash vars: #{headers.inspect}"

    return headers
  end

  def body
    return {} if self.response == '' or self.response.nil?
    hash = JSON.parse(self.response)
    body = hash['results']['bindings']
    return body
  end

  def count_orgs
    body = self.body
    return body.length
  end

  private

  def sanitize_request_string
    # exotic whitespace characters will cause wikidata to reject the query
    self.request.gsub!(/\u00A0+/, ' ')
  end
end
