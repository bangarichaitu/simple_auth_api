module Api
  module V1
    class StockInsController < ApplicationController
      before_action :authenticate_user!

      def index
        stock_ins = StockTransaction.in
                      .includes(:company, :category)
                      .order(id: :desc, transaction_date: :desc)

        stock_ins = stock_ins.where(
          company_id: params[:company_id]
        ) if params[:company_id].present?

        stock_ins = stock_ins.where(
          category_id: params[:category_id]
        ) if params[:category_id].present?


        stock_ins = stock_ins.where(
          transaction_date:  Date.iso8601(params[:transaction_date])
        ) if params[:transaction_date].present?

        render json: {
          stock_ins: stock_ins.map { |stock_in| stock_in_json(stock_in) },
          companies: Company.select(:id, :name, :active),
          categories: Category.select(:id, :name)
        }
      end

      def create
        ActiveRecord::Base.transaction do
          company = Company.find(stock_in_params[:company_id])
          category = Category.find(stock_in_params[:category_id])
          raise ArgumentError, "Company should be present" if company.blank?
          raise ArgumentError, "Category should be present" if category.blank?
          quantity = BigDecimal(stock_in_params[:quantity].to_s)
          rate = BigDecimal(stock_in_params[:rate].to_s)
          raise ArgumentError, "Quantity must be greater than zero" unless quantity.positive?
          raise ArgumentError, "Rate cannot be negative" if rate.negative?
          balance = StockBalance.create_or_find_by!(
            company: company,
            category: category
          )
          balance.with_lock do
            current_quantity = balance.quantity.presence || 0

            new_quantity = current_quantity + quantity
            balance.update!(quantity: new_quantity)
            stock_transaction = StockTransaction.create!(
                                                          company: company,
                                                          category: category,
                                                          transaction_type: :in,
                                                          quantity: quantity,
                                                          rate: rate,
                                                          balance_after: new_quantity,
                                                          transaction_date: stock_in_params[:transaction_date],
                                                          remarks: stock_in_params[:remarks]
                                                        )
            render json: stock_transaction, status: :created
          end
        end
        rescue ArgumentError => e
          render json: { errors: [e.message] },
                 status: :unprocessable_entity

        rescue ActiveRecord::RecordInvalid => e
          render json: { errors: e.record.errors.full_messages },
                 status: :unprocessable_entity
      end

      private

      def stock_in_params
        params.require(:stock_transaction).permit(
          :company_id,
          :category_id,
          :quantity,
          :rate,
          :transaction_date,
          :remarks
        )
      end

      def stock_in_json(transaction)
        {
          id: transaction.id,
          company_id: transaction.company_id,
          company_name: transaction.company.name,
          category_id: transaction.category_id,
          category_name: transaction.category.name,
          quantity: transaction.quantity,
          rate: transaction.rate,
          balance_after: transaction.balance_after,
          transaction_date: transaction.transaction_date,
          remarks: transaction.remarks,
          created_at: transaction.created_at,
          cost: (transaction.quantity * transaction.rate).round(2)
        }
      end

    end
  end
end
