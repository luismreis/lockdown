# encoding: utf-8

module Lockdown
  class Permission
    # Name of permission
    attr_accessor :name
    # Array of resource objects that define the access rights for this permission
    attr_accessor :resources

    # @param [String,Symbol] name permission reference. 
    def initialize(name)
      @name = name.to_s
      @resources = []
    end

    # @param [String,Symbol] name resource reference. 
    # @return new resource 
    def resource(name, &block)
      resource =  Lockdown::Resource.new(name)
      resource.instance_eval(&block) if block_given?
      @resources << resource
      resource
    end

    # @return String representing all resources defining this permission
    def regex_pattern
      resources.collect{|r| "(#{r.regex_pattern})"}.join("|")
    end
  end # Permission
end # Lockdown
