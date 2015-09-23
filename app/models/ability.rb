 class Ability
  include Hydra::Ability

  # Define any customized permissions here.
  def custom_permissions

  end

  # Override create permissions, which are blank by default
  def create_permissions
    if user_groups.include?('admin_group') || user_groups.include?('gis_cataloger')
      can [:new, :create], ActiveFedora::Base
    end
  end

  def authorize_collection
    if !user_groups.include?('admin_group') || !user_groups.include?('io_cataloger')
      raise CanCan::AccessDenied.new("Not authorized kozel!")
    end
  end
end
