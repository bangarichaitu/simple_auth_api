
module Api
  module V1
    class StockReportsController < ApplicationController
      before_action :authenticate_user!

      def index
        balances = StockBalance.includes(:company,:category)
                               .order("companies.name ASC, categories.name ASC")
                               .joins(:company, :category)

        balances = balances.where(company_id: params[:company_id]) if params[:company_id].present?

        balances = balances.where(category_id: params[:category_id]) if params[:category_id].present?

        render json: {
          companies: Company.select(:id, :name),
          categories: Category.select(:id, :name),
          stock_balances: balances.map do |balance|
            {
              id: balance.id,
              company_id: balance.company_id,
              company_name: balance.company.name,
              category_id: balance.category_id,
              category_name: balance.category.name,
              quantity: balance.quantity
            }
          end,
          total_stock: balances.sum(:quantity)
        }
      end
    end
  end
end
