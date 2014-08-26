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
     can [:new, :create, :edit, :update], NyucoreRdfDatastream do |ds|
      ds.dsid.to_sym == :native_metadata
    end   
  end



end
