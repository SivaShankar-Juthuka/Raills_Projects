class ApplicationController < ActionController::Base
    before_action :set_current_user
    before_action :check_session_timeout
  
    def set_current_user
      if session[:user_id]
        if RecordSession.where(session_id: session[:user_id], active_session: true).exists?
          Current.user ||= User.find(RecordSession.find_by(session_id: session[:user_id]).user_id)
        else
          session[:user_id] = nil
        end
      end
    end
  
    def require_user_logged_in!
      if Current.user.nil?
        redirect_to login_path, alert: "You must be signed in to do this."
      end
    end
  
    def check_session_timeout
        if session[:user_id]
          latest_session = RecordSession.find_by(session_id: session[:user_id])
          if latest_session && Time.current > latest_session.session_expiry
            session[:user_id] = nil
            reset_session
            redirect_to login_path, alert: "Your session has timed out. Please sign in again."
          end
        end
    end

  end
  