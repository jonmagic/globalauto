class User < ActiveRecord::Base
  validates_length_of :login, :within => 3..40
  validates_length_of :password, :within => 4..40
  validates_presence_of :firstname, :lastname, :login, :password, :password_confirmation, :salt
  validates_confirmation_of :password
  validates_uniqueness_of :login
  
  attr_protected :id, :salt, :admin
  attr_accessor :password, :password_confirmation
  
  def password=(pass)
    @password = pass
    self.salt = User.random_string(10) if !self.salt?
    self.hashed_password = User.encrypt(@password, self.salt)
  end
  
  def self.authenticate(login, pass)
    u = find(:first, :conditions => ["login = ?", login])
    return nil if u.nil?
    return u if User.encrypt(pass, u.salt) == u.hashed_password
    nil
  end
  
  protected
  
    def self.encrypt(pass, salt)
      Digest::SHA1.hexdigest(pass+salt)
    end
    
    def self.random_string(len)
      #generate a random password consisting of strings and digits
      chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
      newpass = ""
      1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
      return newpass
    end
  
end
