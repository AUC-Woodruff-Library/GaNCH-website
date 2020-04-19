class Query < ApplicationRecord
  validates :title, presence: true
  validates :request, presence: true
end
