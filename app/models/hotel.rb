class Hotel < ApplicationRecord
  has_many :stock_transactions,
           dependent: :restrict_with_error

  validates :name, presence: true

	validates :phone,
	        format: {
	          with: /\A[0-9+\-\s()]{7,20}\z/,
	          message: "is invalid"
	        },
	        allow_blank: true
	scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
end