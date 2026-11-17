module Api
  module V1
    class CategoriesController < ApplicationController
      before_action :authenticate_user!
      before_action :set_category, only: [:show, :update, :destroy, :toggle_status]

      def index
        render json: Category.order(created_at: :desc)
      end

      def show
        render json: @category
      end

      def create
        category = Category.new(category_params)

        if category.save
          render json: category, status: :created
        else
          render json: { errors: category.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      def update
        if @category.update(category_params)
          render json: @category
        else
          render json: { errors: @category.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      def destroy
        if @category.destroy
          render json: { message: "Category deleted successfully" }
        else
          render json: { errors: @category.errors.full_messages },
                 status: :unprocessable_entity
        end
      end


      def toggle_status
        @category.update!(active: !@category.active)

        render json: {
          message: "Category status updated successfully",
          company: @category
        }
      rescue ActiveRecord::RecordInvalid
        render json: {
          errors: @category.errors.full_messages
        }, status: :unprocessable_entity
      end

      private

      def set_category
        @category = Category.find(params[:id])
      end

      def category_params
        params.require(:category).permit(:name, :description)
      end
    end
  end
end