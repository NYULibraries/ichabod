class User < ActiveRecord::Base
# Connects this user object to Hydra behaviors.
 include Hydra::User
# Connects this user object to Blacklights Bookmarks.
 include Blacklight::User
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  #devise :database_authenticatable, :registerable,
  #       :recoverable, :rememberable, :trackable, :validatable

  serialize :user_attributes

  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account.
  def to_s
    email
  end

  # Configure authlogic
  acts_as_authentic do |c|
    c.validations_scope = :username
    c.validate_password_field = false
    c.require_password_confirmation = false
    c.disable_perishable_token_maintenance = true
  end

  # Override core Hydra functions which use Devise hardcoded
  def user_key
    username
  end

  def self.find_by_user_key(key)
    self.send("find_by_username".to_sym, key)
  end

  def admin?
    true if ["ba36"].include? username
  end

  def groups
    [ENV['PDS_HANDLE']]
    
  end

end
