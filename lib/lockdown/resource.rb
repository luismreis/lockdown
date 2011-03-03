# encoding: utf-8

module Lockdown
  class Resource
    class << self
      attr_reader :resources

      # When a new resource is created, this method is called to register the root
      def register_regex(resource)
        resource = "(#{resource})"
        @resources << resource unless @resources.include?(resource)
      end

      # @return [String] all registered regular expressions joined by a pipe
      def all_access
        @resources.join(Lockdown::DELIMITER)
      end

      # Reset resources to empty array
      def reset_resources
        @resources = []
      end
    end # class block

    # Initialize resources to empty array
    @resources = []

    # Name of the resource
    attr_accessor :name
    # Regular expression pattern
    attr_accessor :regex_pattern
    # The only methods restricted on the resource
    attr_accessor :exceptions
    # The only methods allowed on the resource
    attr_accessor :inclusions


    # @param [String,Symbol] name resource reference. 
    def initialize(name)
      @name = name.to_s
      @regex_pattern = "\/#{@name}(\/.*)?"
      self.class.register_regex(@regex_pattern)
    end

    # @param *[String,Symbol] only methods restricted on the resource
    def except(*methods)
      return if methods.empty?
      @exceptions = methods.collect{|m| m.to_s}
      @regex_pattern = "\/#{@name}(?!\/(#{@exceptions.join('|')}))(\/.*)?"
    end

    # @param *[String,Symbol] only methods allowed on the resource
    def only(*methods)
      return if methods.empty?
      @inclusions = methods.collect{|m| m.to_s}
      @regex_pattern = "\/#{@name}\/(#{@inclusions.join('|')})(\/)?"
    end
  end # Resource
end # Lockdown
