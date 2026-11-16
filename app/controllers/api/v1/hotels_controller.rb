module Api
  module V1
    class HotelsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_hotel, only: [:show, :update, :destroy, :toggle_status]

      def index
        hotels = Hotel.order(created_at: :desc)

        render json: hotels
      end

      def show
        render json: @hotel
      end

      def create
        hotel = Hotel.new(hotel_params)

        if hotel.save
          render json: hotel, status: :created
        else
          render json: { errors: hotel.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      def update
        if @hotel.update(hotel_params)
          render json: @hotel
        else
          render json: { errors: @hotel.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      def destroy
        if @hotel.destroy
          render json: { message: "Hotel deleted successfully" }
        else
          render json: { errors: @hotel.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      def toggle_status
        @hotel.update!(active: !@hotel.active)

        render json: {
          message: "Hotel status updated successfully",
          hotel: @hotel
        }
      rescue ActiveRecord::RecordInvalid
        render json: {
          errors: @hotel.errors.full_messages
        }, status: :unprocessable_entity
      end

      private

      def set_hotel
        @hotel = Hotel.find(params[:id])
      end

      def hotel_params
        params.require(:hotel).permit(
          :name,
          :contact_person,
          :phone,
          :address
        )
      end
    end
  end
end