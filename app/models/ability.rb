class Ability
  include Hydra::Ability
  
  # Define any customized permissions here.
  def custom_permissions
    # Limits deleting objects to a the admin user
    #
    if current_user.admin?
      can [:destroy], ActiveFedora::Base
    end

    # Limits creating new objects to a specific group
    #
     if user_groups.include? 'gis_cataloger'
#       alias_action :create, :read, :update, :destroy, :to => :crud
       can [:manage], Nyucore do |n|
          n.type == "Geospatial Data"
       end
         
     end
  end
end
