# encoding: utf-8

module Lockdown
  class Delivery
    class << self
      # @return [true|false] if the given path and method are allowed  
      def allowed?(path, access_rights = nil)
        return true if path == '/'

        begin
          ::Authorization.configure
        rescue NameError
        end

        access_rights ||= Lockdown::Configuration.public_access

        access_rights_regex = Lockdown.regex(access_rights)

        path += "/" unless path =~ /\/$/

        access_rights_regex =~ path ? true : false
      end
    end # class block
  end # Delivery
end # Lockdown
