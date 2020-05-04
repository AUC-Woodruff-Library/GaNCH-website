class User < ApplicationRecord
  has_secure_password
  has_many :queries

  validates :email, format: { with: /@/, message: "must have an @"}, uniqueness: true
  validates :name, presence: true
end
