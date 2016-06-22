module WeatherWeb
  class User < ActiveRecord::Base
    has_secure_password
      def create(params)
        @user = User.new(params)
          if @user.save
            true
          end
      end

      def login(params)
        @user = User.find_by(params[:username])
        if @user && @user.authenticate(params[:password])
          current_user = @user.id
          true
        end
      end

      def logout
         session[:id] = nil
      end

  end
end
