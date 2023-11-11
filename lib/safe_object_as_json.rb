# frozen_string_literal: true

require "active_support/all"

module SafeObjectAsJson
  # ActiveSupport 7 is adding support for filtering hash values with :only and :except options.
  SUPPORT_FILTERING = (ActiveSupport.version.canonical_segments.first > 6)

  VERSION = File.read(File.expand_path("../VERSION", __dir__)).chomp
end

class Object
  # Converts any object to JSON by creating a hash out of it's instance variables.
  # If there is a circular reference within an object hierarchy, then duplicate
  # objects will be omitted in order to avoid infinite recursion.
  #
  # @param [Hash] options
  # @return [Hash]
  def as_json(options = nil)
    if respond_to?(:to_hash)
      to_hash.as_json(options)
    else
      # The default as_json serializer serializes the instance variables as name value pairs.
      # In order to prevent infinite recursion, we keep track of the object already used
      # in the serialization and omit them if they are included recursively.
      references = (Thread.current[:object_as_json_references] || Set.new)
      begin
        Thread.current[:object_as_json_references] = references if references.empty?
        references << object_id
        hash = {}

        # Apply :only and :except filter from the options to the hash of instance variables.
        values = instance_values
        if options && SafeObjectAsJson::SUPPORT_FILTERING
          only_attr = options[:only]
          if only_attr
            values = values.slice(*Array(only_attr).map(&:to_s))
          else
            except_attr = options[:except]
            if except_attr
              values = values.except(*Array(except_attr).map(&:to_s))
            end
          end
        end

        values.each do |name, value|
          unless references.include?(value.object_id) || value.is_a?(Proc) || value.is_a?(IO)
            references << value
            hash[name] = (options.nil? ? value.as_json : value.as_json(options.dup))
          end
        end
        hash
      ensure
        references.delete(object_id)
        Thread.current[:object_as_json_references] = nil if references.empty?
      end
    end
  end
end
