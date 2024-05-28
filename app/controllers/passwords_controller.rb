class PasswordsController < ApplicationController
    before_action :require_user_logged_in!

    def edit

    end

    def update
        if Current.user.update(password_params)
            redirect_to root_path, notice: "Password successfully updated."
        else
            render :edit, alert: "Password and Password confirmation is not matched."
        end
    end

    private

    def password_params
        params.require(:user).permit(:password, :password_confirmation)
    end
end