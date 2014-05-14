class UserSession < Authlogic::Session::Base
  pds_url "https://logindev.library.nyu.edu"
  calling_system "hydra"
  anonymous true
  redirect_logout_url "http://bobcat.library.nyu.edu"

  def attempt_sso?
    (Rails.env.development? || Rails.env.test?) ? false : super
  end
end
