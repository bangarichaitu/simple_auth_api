module Api
  module V1
    class CompaniesController < ApplicationController
      before_action :authenticate_user!
      before_action :set_company, only: [:show, :update, :destroy, :toggle_status]

      def index
        companies = Company.order(created_at: :desc)

        render json: companies
      end

      def show
        render json: @company
      end

      def create
        company = Company.new(company_params)

        if company.save
          render json: company, status: :created
        else
          render json: { errors: company.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      def update
        if @company.update(company_params)
          render json: @company
        else
          render json: { errors: @company.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      def destroy
        if @company.destroy
          render json: { message: "Company deleted successfully" }
        else
          render json: { errors: @company.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      def toggle_status
        @company.update!(active: !@company.active)

        render json: {
          message: "Company status updated successfully",
          company: @company
        }
      rescue ActiveRecord::RecordInvalid
        render json: {
          errors: @company.errors.full_messages
        }, status: :unprocessable_entity
      end

      private

      def set_company
        @company = Company.find(params[:id])
      end

			def company_params
			  params.require(:company).permit(
			    :name,
			    :address,
			    :contact_number
			  )
			end
    end
  end
end
