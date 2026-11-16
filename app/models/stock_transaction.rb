class StockTransaction < ApplicationRecord
  belongs_to :company
  belongs_to :category
  belongs_to :hotel, optional: true

  enum :transaction_type, {
    in: "IN",
    out: "OUT"
  }

  validates :company_id, presence: true
  validates :category_id, presence: true
  validates :quantity, numericality: { greater_than: 0 }
  validates :rate, numericality: { greater_than_or_equal_to: 0 }
  validates :transaction_date, presence: true

  validate :hotel_required_for_stock_out

  private

  def hotel_required_for_stock_out
    if out? && hotel_id.blank?
      errors.add(:hotel_id, "must be selected for stock OUT")
    elsif in? && hotel_id.present?
      errors.add(:hotel_id, "must be blank for stock IN")
    end
  end
end