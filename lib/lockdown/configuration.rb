# encoding: utf-8

module Lockdown
  module Configuration
    class << self
      # Path to redirect to if access is denied. 
      # Default: '/'        
      attr_accessor :access_denied_path
      # Regex string of paths that are publicly accessible. 
      # Default "\/"
      attr_accessor :public_access
      # Array of paths that are restricted to an authenticated user.
      # Default ""
      attr_accessor :protected_access
      # Array of permission objects that defines the access to the application.
      # Default []
      attr_accessor :permissions
      # Method used to get the id of the user responsible for 
      # the current action.
      # Default :current_user_id
      attr_accessor :who_did_it
      # User id to associate to system actions
      # Default 1
      attr_accessor :default_who_did_it
      # Redirect to path on access violation
      # Default "/"
      attr_accessor :access_denied_path
      # Redirect to path on successful login
      # Default "/"
      attr_accessor :successful_login_path
      # When using the links helper, this character will be 
      # used to separate the links.
      # Default "|"
      attr_accessor :link_separator
      # The model used to represent the grouping of permisssion. Common
      # choices are 'Role' and 'UserGroup'.
      # Default "UserGroup"
      attr_accessor :user_group_model
      # The model used to represent the user. Common choices 
      # are 'User' and 'Person'.
      # Default "User"
      attr_accessor :user_model

      # Set defaults.
      def reset
        @access_denied_path           = "/"
        @public_access                = ""
        @protected_access             = ""
        @permissions                  = []

        @who_did_it                   = :current_user_id
        @default_who_did_it           = 1
        @logout_on_access_violation   = false
        @access_denied_path           = "/"
        @successful_login_path        = "/"

        @link_separator               = "|"

        @user_group_model             = "UserGroup",
        @user_model                   = "User"
      end

      def has_permission?(permission)
        permissions.any?{|p| permission.name == p.name}
      end
    end

    self.reset
  end # Configuration
end # Lockdown
