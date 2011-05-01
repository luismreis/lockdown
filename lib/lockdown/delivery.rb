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

        access_rights ||= Lockdown::Configuration.public_access

        path += "/" unless path =~ /\/$/
        path = "/" + path unless path =~ /^\//

        access_rights.split(Lockdown::DELIMITER).each do |ar|
          if (Lockdown.regex(ar) =~ path) == 0
            return true
          end
        end

        return false
      end
    end # class block
  end # Delivery
end # Lockdown
