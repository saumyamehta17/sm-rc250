require 'bcrypt'
class User < ActiveRecord::Base
  #has_secure_password
  attr_accessor :password, :password_confirmation
  validates_uniqueness_of :email
  validates_presence_of :password, on: :save
  validates_confirmation_of :password_confirmation
  before_save :encrypt_password
  before_create {generate_auth_token(:auth_token)}

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def generate_token(token)
    begin
      self[token] = SecureRandom.urlsafe_base64
    end while User.exists?(token => self[token])
  end

  def generate_auth_token(token)
    begin
      self[token] = SecureRandom.urlsafe_base64
    end while User.exists?(token => self[token])
  end
  def encrypt_password
    if password.present?
      self.password_digest = BCrypt::Password.create(password)
    end
  end

  def check_pass(pass)
    BCrypt::Password.new(password_digest) == pass
  end

  def self.authenticate(email, password)
    user = User.find_by_email(email)
    if user && user.check_pass(password)
      user
    else
      nil
    end
  end

  def self.new_guest
    new(guest: true)
  end

  def name
    guest? ? 'Guest' : email
  end

  def move_to(user)
  end
end
