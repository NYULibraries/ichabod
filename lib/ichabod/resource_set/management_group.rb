module Ichabod
  module ResourceSet
    class ManagementGroup
      attr_reader :name, :owner, :members

      def initialize(name, owner, *members)
        unless owner.is_a? User
          raise ArgumentError.new("Expecting #{owner} to be a User")
        end
        @name = name
        @owner = owner
        @members = [owner]
        members.each do |member|
          unless member.is_a? User
            raise ArgumentError.new("Expecting #{member} to be a User")
          end
          @members << member
        end
      end
    end
  end
end
