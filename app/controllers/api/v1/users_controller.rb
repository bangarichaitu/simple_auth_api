module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_user!
      before_action :set_user, only: %i[show update destroy toggle_status]

      rescue_from ActiveRecord::RecordNotFound, with: :user_not_found

      # GET /api/v1/users
     def index
        per_page = params[:per_page].to_i
        per_page = 10 unless per_page.positive?
        per_page = [per_page, 100].min

        users = User.all

        # Search by name or email
        if params[:search].present?
          search_term = "%#{User.sanitize_sql_like(params[:search].strip)}%"

          users = users.where(
            "name LIKE :search OR email LIKE :search",
            search: search_term
          )
        end

        users = users.order(created_at: :desc)
                     .page(params[:page])
                     .per(per_page)

        render json: {
          users: users.map { |user| user_json(user) },
          pagination: {
            current_page: users.current_page,
            per_page: per_page,
            total_pages: users.total_pages,
            total_count: users.total_count,
            from: users.total_count.zero? ? nil : users.offset_value + 1,
            to: users.total_count.zero? ? nil : users.offset_value + users.size,
            next_page: users.next_page,
            prev_page: users.prev_page
          }
        }, status: :ok
      end

      # GET /api/v1/users/:id
      def show
        render json: { user: user_json(@user) }, status: :ok
      end

      # POST /api/v1/users
      def create
        user = User.new(user_params)

        if user.save
          render json: {
            message: "User created successfully",
            user: user_json(user)
          }, status: :created
        else
          render json: {
            errors: user.errors
          }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/users/:id
      def update
        attributes = user_params

        # Allow updates without changing the password.
        if attributes[:password].blank?
          attributes = attributes.except(
            :password,
            :password_confirmation
          )
        end

        if @user.update(attributes)
          render json: {
            message: "User updated successfully",
            user: user_json(@user)
          }, status: :ok
        else
          render json: {
            errors: @user.errors
          }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/users/:id
      def destroy
        @user.destroy!

        render json: {
          message: "User deleted successfully"
        }, status: :ok
      end


      def toggle_status
        @user.update!(active: !@user.active)

        render json: {
          message: "User status updated successfully",
          user: @user
        }
      rescue ActiveRecord::RecordInvalid
        render json: {
          errors: @user.errors.full_messages
        }, status: :unprocessable_entity
      end

      private

      def set_user
        @user = User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(
          :name,
          :email,
          :password,
          :password_confirmation,
          :is_admin
        )
      end

      def user_json(user)
        {
          id: user.id,
          name: user.name,
          email: user.email,
          created_at: user.created_at,
          status: user.active,
          is_admin: user.is_admin?
        }
      end

      def user_not_found
        render json: {
          error: "User not found"
        }, status: :not_found
      end
    end
  end
end
