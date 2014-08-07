module SessionsHelper

  def sign_in(user)
    remember_token = User.new_remember_token           #assigns random 16 char with new_remember_token method to user.
    cookies.permanent[:remember_token] = remember_token    #this sets random 16 char in the cookies
    user.update_attribute(:remember_token, User.digest(remember_token))   #updates remember_token in db with hashed remember_token (note: the remember_token in cookie is not hashed)
    self.current_user = user    #assigns current_user in this method.
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user   #assign user to current_user
  end

  def current_user
    remember_token = User.digest(cookies[:remember_token])       #Hashing the random 16 chars stored in cookies
    @current_user ||= User.find_by(remember_token: remember_token)  #use the hashed random_token to find match in the db
  end

  def current_user?(user)
  	user == current_user
  end

  def sign_out
    current_user.update_attribute(:remember_token, User.digest(User.new_remember_token))
    cookies.delete(:remember_token)
    self.current_user = nil
  end	
end