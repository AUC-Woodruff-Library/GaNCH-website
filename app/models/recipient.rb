class Recipient < ApplicationRecord
  validates :organization, presence: true
end
