module Api
  module V1
    class SessionsController < Devise::SessionsController
      skip_before_action :verify_signed_out_user, only: :destroy

      def create
        self.resource = warden.authenticate!(auth_options)
        sign_in(resource_name, resource, store: false)

        render json: {
          message: "Login successful",
          user: {
            id: resource.id,
            name: resource.name,
            email: resource.email
          }
        }, status: :ok
      end

      def destroy
        token = request.headers["Authorization"]&.split&.last
        user = warden.authenticate(scope: :user)

        if user && token.present?
          payload = JWT.decode(
            token,
            Devise::JWT.config.secret,
            true,
            algorithm: "HS256"
          ).first

          if payload["jti"] == user.jti
            user.update!(jti: SecureRandom.uuid)
          end
        end

        render json: { message: "Logout successful" }, status: :ok
      rescue JWT::DecodeError
        render json: { error: "Invalid token" }, status: :unauthorized
      end
    end
  end
end