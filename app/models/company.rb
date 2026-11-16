class Company < ApplicationRecord
  has_many :stock_balances, dependent: :restrict_with_error
  has_many :stock_transactions, dependent: :restrict_with_error

  validates :name,
            presence: true,
            uniqueness: { case_sensitive: false }

  validates :contact_number,
            format: {
              with: /\A[0-9+\-\s()]{7,20}\z/,
              message: "is invalid"
            },
            allow_blank: true
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
end