# encoding: utf-8

module Lockdown
  class Delivery
    class << self
      # @return [true|false] if the given path is allowed
      def allowed?(path, access_rights = nil)
        begin
          ::Authorization.configure
        rescue NameError
        end

        path += "/" unless path =~ /\/$/
        path = "/" + path unless path =~ /^\//

        access_rights ||= [Lockdown::Configuration.public_access]

        access_rights_regex = Lockdown.regex(access_rights)

        return access_rights.any? { |access_rights_group|
          (Lockdown.regex(access_rights_group) =~ path) == 0
        }
      end
    end # class block
  end # Delivery
end # Lockdown
