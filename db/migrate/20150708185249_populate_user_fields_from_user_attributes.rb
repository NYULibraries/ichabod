class PopulateUserFieldsFromUserAttributes < ActiveRecord::Migration
  def up
    say_with_time "Migrating User Attributes" do
      User.class_eval { serialize :user_attributes }
      User.all.each do |user|
        unless user.user_attributes.blank?
          user.update_attribute :aleph_id, user.user_attributes[:nyuidn] rescue ''
          user.update_attribute :patron_status, user.user_attributes[:bor_status] rescue ''
          user.update_attribute :institution_code, user.user_attributes[:primary_institution] rescue ''
        end
      end
    end
  end

  def down
  end
end
