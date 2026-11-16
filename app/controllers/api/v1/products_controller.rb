module Api
  module V1
    class ProductsController < ApplicationController

      before_action :set_product, only: [:show, :update, :destroy]

      def index
        products = Product.includes(:category).order(created_at: :desc)

        if params[:search].present?
          products = products.where(
            "products.name LIKE :search OR products.sku LIKE :search",
            search: "%#{params[:search]}%"
          )
        end

        if params[:category_id].present?
          products = products.where(category_id: params[:category_id])
        end

        if params[:low_stock] == "true"
          products = products.where(
            "quantity <= minimum_stock"
          )
        end

        page = [params[:page].to_i, 1].max
        per_page = params[:per_page].to_i
        per_page = 10 unless per_page.positive?
        per_page = [per_page, 100].min

        total_count = products.count

        products = products
          .offset((page - 1) * per_page)
          .limit(per_page)

        render json: {
          products: products.map { |product| product_json(product) },
          pagination: {
            current_page: page,
            per_page: per_page,
            total_count: total_count,
            total_pages: (total_count.to_f / per_page).ceil
          }
        }
      end

      def show
        render json: product_json(@product)
      end

      def create
        product = Product.new(product_params)

        if product.save
          render json: product_json(product), status: :created
        else
          render json: { errors: product.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      def update
        if @product.update(product_params)
          render json: product_json(@product)
        else
          render json: { errors: @product.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      def destroy
        if @product.destroy
          render json: { message: "Product deleted successfully" }
        else
          render json: {
            errors: @product.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      private

      def set_product
        @product = Product.find(params[:id])
      end

      def product_params
        params.require(:product).permit(
          :name,
          :sku,
          :description,
          :category_id,
          :purchase_price,
          :selling_price,
          :quantity,
          :minimum_stock,
          :active
        )
      end

      def product_json(product)
        {
          id: product.id,
          name: product.name,
          sku: product.sku,
          description: product.description,
          category_id: product.category_id,
          category_name: product.category.name,
          purchase_price: product.purchase_price,
          selling_price: product.selling_price,
          quantity: product.quantity,
          minimum_stock: product.minimum_stock,
          active: product.active,
          low_stock: product.low_stock?,
          created_at: product.created_at
        }
      end
    end
  end
end