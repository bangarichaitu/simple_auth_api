module Api
  module V1
    class RegistrationsController < ApplicationController
      def create
        user = User.new(user_params)

        if user.save
          render json: {
            message: "Signup successful",
            user: {
              id: user.id,
              name: user.name,
              email: user.email
            }
          }, status: :created
        else
          render json: {
          	errors: user.errors
					    .group_by_attribute
					    .transform_values do |messages|
					      messages.map(&:full_message).uniq
					    end
          }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(
          :name, :email, :password, :password_confirmation
        )
      end
    end
  end
end