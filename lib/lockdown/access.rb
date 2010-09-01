# encoding: utf-8

module Lockdown
  module Access
    # Define permision that defines how your application is accessed. 
    #     # All methods on the site resource will be open to users who have
    #     # this permission.
    #     permission :public_pages do
    #       resource :site
    #     end
    #
    #     # Can use multiple resource statements
    #     permission :public_pages do
    #       resource :site
    #       resource :posts
    #     end
    #
    #     # Only methods show, edit and update on the users resource will 
    #     # be open to users who have this permission.
    #     permission :my_account_pages do
    #       resource :users  do
    #         only :show, :edit, :update
    #       end
    #     end
    #
    #     # All methods except destroy on the users resource will be 
    #     # open to users who have this permission.
    #     permission :manage_users do
    #       resource :users  do
    #         except :destroy
    #       end
    #     end
    #
    # @param [String,Symbol] name permission reference. 
    # @yield [Lockdown::Permission.new(name)] new permission object
    def permission(name, &block)
      permission =  Lockdown::Permission.new(name)   
      if block_given?
        permission.instance_eval(&block) 
      else
        permission.resource(permission.name)
      end

      unless Lockdown::Configuration.has_permission?(permission)
        Lockdown::Configuration.permissions << permission 
      end

      permission
    end

    # Define which permissions are accessible to everyone
    #   public_access :site, :user_registration
    #
    # @param *[String,Symbol] permissions that are accessible to everyone
    def public_access(*permissions)
      Lockdown::Configuration.public_access = regexes(permissions)
    end

    # Define which permissions are accessible to everyone
    #   protected_access :my_account, :site_administration
    #
    # @param *[String,Symbol] permissions that are accessbile to authenticated users
    def protected_access(*permissions)
      Lockdown::Configuration.protected_access = regexes(permissions)
    end


    # Method called by Lockdown::Watch to trigger parsing of class methods
    def configure
      true
    end

    private

    def regexes(permissions)
      permissions.collect!{|p| p.to_s}
      perms = Lockdown::Configuration.permissions.select{|p| permissions.include?(p.name)}
      perms.collect{|p| p.regex_pattern}.join("|")
    end

  end # Access
end # Lockdown
