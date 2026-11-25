module Api
  module V1
    class ProfilesController < ApplicationController
      before_action :authenticate_user!

      def show
        render json: {
          message: "Profile fetched successfully",
          user: {
            id: current_user.id,
            name: current_user.name,
            email: current_user.email,
            created_at: current_user.created_at,
            is_admin: current_user.is_admin?
          }
        }, status: :ok
      end
    end
  end
end