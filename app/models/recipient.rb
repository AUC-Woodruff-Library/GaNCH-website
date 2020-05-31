class Recipient < ApplicationRecord
  validates :name, presence: true
end
