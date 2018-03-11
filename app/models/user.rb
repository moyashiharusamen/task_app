class User < ApplicationRecord
  has_many :tasks, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }, email: true
  validates :password, length: { minimum: 8 }
  validates :password_confirmation, presence: true

  has_secure_password
end
