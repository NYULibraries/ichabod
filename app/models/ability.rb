class Ability
  include Hydra::Ability
  
  # Define any customized permissions here.
  def custom_permissions
    # Limits deleting objects to a the admin user
    #
    if current_user.admin?
      can [:destroy], ActiveFedora::Base
    end

    

    def user_groups
      return @user_groups if @user_groups

      @user_groups = default_user_groups
      @user_groups |= current_user.groups if current_user and current_user.respond_to? :groups
      @user_groups |= ['registered'] unless current_user.new_record?
      @user_groups
    end
  end
end
