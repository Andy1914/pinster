require 'devise'

module Devise
  module Strategies
    class Base  < ::Warden::Strategies::Base
      def mapping
        # @mapping ||= begin
          mapping = Devise.mappings[scope]
          raise "Could not find mapping for #{scope}" unless mapping
          mapping
        # end
      end
    end
  end
end