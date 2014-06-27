class Ability
  include Hydra::Ability

  # Define any customized permissions here.
  def custom_permissions
    # Limits deleting objects to a the admin user
    #
    if current_user.admin?
      can [:destroy], ActiveFedora::Base
    end

    #aliasing create/read/update/delete actions 
    alias_action :create, :read, :update, :destroy, :to => :crud
    # Limits creating new objects to a specific group
     if user_groups.include? 'gis_cataloger'
       can [:crud], Nyucore, type: "Geospatial Data" if user_groups.include? 'gis_cataloger'
         
     end
  end
end
