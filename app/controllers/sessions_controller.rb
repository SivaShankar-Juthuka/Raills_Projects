class SessionsController < ApplicationController
    skip_before_action :check_session_timeout, only: [:new, :create]

    def new
        @user = User.new
    end

    def create
        user = User.find_by(email: params[:email])
        if user.present? && user.authenticate(params[:password])
          session_id = SecureRandom.uuid
          session[:user_id] = session_id
          record_session = RecordSession.new(session_params.merge(session_id: session_id, user_id: user.id, active_session: true, session_expiry: 15.minutes.from_now))
          if record_session.save
            redirect_to root_path, notice: "Logged in successfully."
          else
            render :new, alert: "Error creating session."
          end
        else
          flash[:alert] = "Invalid email or password"
          render :new
        end
    end
      

    def destroy
        if session[:user_id]
            latest_session = RecordSession.find_by(user_id: session[:user_id])
            if latest_session
              latest_session.update(active_session: false)
              puts latest_session.active_session
            end
        end
        puts
        session[:user_id] = nil
        reset_session
        redirect_to login_path, notice: 'Signed out successfully.'
      end

    private

    def session_params
        params.permit(:session_id, :user_id, :active_session, :session_expiry)
    end
end