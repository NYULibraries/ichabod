module Ichabod
  module ResourceSet
    class ManagementGroup
      attr_reader :name, :owner, :members

      def initialize(name, *members)
        @name = name
        @members = []
        unless members.blank?
          members.each do |member|
            unless member.is_a? User
              raise ArgumentError.new("Expecting #{member} to be a User")
            end
          end
          @owner =  members.first
          @members = members
        end
      end
    end
  end
end
