class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_filter :require_valid_omniauth, only: :nyulibraries
  def nyulibraries
    # Find existing or initialize new user,
    # and save new attributes each time
    @user = find_user_with_or_without_provider.first_or_initialize(attributes_from_omniauth)
    @user.update_attributes(attributes_from_omniauth)

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      logger.info(find_message(:success, kind: "NYU Libraries"))
    else
      session["devise.nyulibraries_data"] = request.env["omniauth.auth"]
      redirect_to root_path
    end
  end

  def find_user_with_or_without_provider
    @find_user_with_or_without_provider ||= (find_user_with_provider.present?) ? find_user_with_provider : find_user_without_provider
  end

  def find_user_with_provider
    @find_user_with_provider ||= User.where(username: omniauth.uid, provider: omniauth.provider)
  end

  def find_user_without_provider
    @find_user_without_provider ||= User.where(username: omniauth.uid, provider: "")
  end

  def require_valid_omniauth
    head :bad_request unless valid_omniauth?
  end

  def valid_omniauth?
    omniauth.present? && omniauth.provider.to_s == 'nyulibraries'
  end

  def omniauth
    @omniauth ||= request.env["omniauth.auth"]
  end

  def omniauth_provider
    @omniauth_provider ||= omniauth.provider
  end

  def attributes_from_omniauth
    {
      provider: omniauth_provider,
      email: omniauth_email,
      firstname: omniauth_firstname,
      lastname: omniauth_lastname,
      institution_code: omniauth_institution,
      aleph_id: omniauth_aleph_id,
      patron_status: omniauth_patron_status
    }
  end

  def omniauth_email
    @omniauth_email ||= omniauth.info.email
  end

  def omniauth_firstname
    @omniauth_firstname ||= omniauth.info.first_name
  end

  def omniauth_lastname
    @omniauth_lastname ||= omniauth.info.last_name
  end

  def omniauth_institution
    @omniauth_institution ||= omniauth.extra.institution_code
  end

  def omniauth_identities
    @omniauth_identities ||= omniauth.extra.identities
  end

  def omniauth_aleph_identity
    @omniauth_aleph_identity ||= omniauth_identities.find do |omniauth_identity|
      omniauth_identity.provider == 'aleph'
    end
  end

  def omniauth_aleph_id
    unless omniauth_aleph_identity.blank?
      @omniauth_aleph_id ||= omniauth_aleph_identity.uid
    end
  end

  def omniauth_patron_status
    unless omniauth_aleph_identity.blank?
      @omniauth_patron_status ||= omniauth_aleph_identity.properties.patron_status
    end
  end
end
