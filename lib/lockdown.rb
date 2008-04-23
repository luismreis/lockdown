$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Lockdown
  class << self
    def format_controller_action(url)
      url.split("/").delete_if{|p| p.to_i > 0 || p.length == 0}.join("/")
    end

    def format_controller(ctr)
      ctr.split("/").delete_if{|p| p.length == 0}.join("/")
    end

    def project_root
      project_related_value("Merb.root", "RAILS_ROOT")
    end
                       
    def merb_app?
      Object.const_defined?("Merb") && Merb.const_defined?("AbstractController")
    end

    def rails_app?
      Object.const_defined?("ActionController") && ActionController.const_defined?("Base")
    end

    def controller_parent
      project_related_value("Merb::Controller", "ActionController::Base")
    end

    def datamapper_orm?
      Object.const_defined?("DataMapper") && DataMapper.const_defined?("Base")
    end

    def active_record_orm?
      Object.const_defined?("ActiveRecord") && ActiveRecord.const_defined?("Base")
    end

    def orm_parent
      if datamapper_orm?
        DataMapper::Base
      elsif active_record_orm?
        ActiveRecord::Base
      else
        raise NotImplementedError, "ORM unknown to Lockdown!  Lockdown recognizes DataMapper and ActiveRecord"
      end
    end

    private

    def project_related_value(merb_val, rails_val)
      if merb_app?
        eval(merb_val)
      elsif rails_app?
        eval(rails_val)
      else
        raise NotImplementedError, "Project type unkown to Lockdown"
      end

    end
  end # class block
  
  require "lockdown/helper.rb"
  require "lockdown/controller_inspector.rb"
  require "lockdown/controller.rb"
  require "lockdown/model.rb"
  require "lockdown/view.rb"

  module Permissions#:nodoc:
    class << self
      include Lockdown::ControllerInspector
      
      def[](sym)
        raise NameError.new("#{sym} is not defined") unless respond_to?(sym)
        send(sym)
      end
      
      def access_rights_for(ary)
        ary.collect{|m| send(m)}.flatten
      end

      def all
        all_controllers
      end
    end # class block
  end # permissions

  module UserGroups#:nodoc:
    class << self
      def[](sym)
        permissions(sym).collect{|rec| Lockdown::Permissions[rec]}.flatten
      end

      def permissions(sym)
        if self.private_records.include?(sym)
          return self.send(sym)
        end

        static_permissions(sym)
      end

      def static_permissions(sym)
        raise NameError.new("#{sym} is not defined") unless respond_to?(sym)
        send(sym)
      end
    end # class block
  end # usergroups

 # module Session
 #   protected 
 #   include Lockdown::Session
 # 
 # end
end

