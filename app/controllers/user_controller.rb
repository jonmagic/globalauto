class UserController < ApplicationController
  before_filter :login_required, :only=>['welcome', 'change_password', 'hidden']

    def signup
      @user = User.new(params[:user])
      if request.post?  
        if @user.save
          session[:user] = User.authenticate(@user.login, @user.password)
          flash[:message] = "Signup successful"
          redirect_to :action => "welcome"          
        else
          flash[:warning] = "Signup unsuccessful"
        end
      end
    end

    def login
      if request.post?
        if session[:user] = User.authenticate(params[:user][:login], params[:user][:password])
          flash[:message]  = "Login successful"
          redirect_to_stored
        else
          flash[:warning] = "Login unsuccessful"
        end
      end
    end

    def logout
      session[:user] = nil
      flash[:message] = 'Logged out'
      redirect_to :action => 'login'
    end
    
    def edit
      @user = session[:user]
    end

    def change_password
      @user = session[:user]
      if request.post?
        @user.update_attributes(:password => params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
        if @user.save
          flash[:message] = "User updated."
          redirect_to "/"
        else
          flash[:message] = "User not updated!"
          redirect_to "/user/edit"
        end
      end
    end

    def welcome
    end
    def hidden
    end

end
