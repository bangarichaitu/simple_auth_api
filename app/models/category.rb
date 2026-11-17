class Category < ApplicationRecord
  has_many :stock_balances, dependent: :restrict_with_error
  has_many :stock_transactions, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
end