class StockBalance < ApplicationRecord
  belongs_to :company
  belongs_to :category
end
