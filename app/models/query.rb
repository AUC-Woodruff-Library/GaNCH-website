class Query < ApplicationRecord
  require "sparql/client"
  extend ActiveModel::Callbacks

  belongs_to :user

  validates :title, presence: true
  validates :request, presence: true

  define_model_callbacks :update

  def headers
    return nil if self.response == '' or self.response.nil?
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
end
