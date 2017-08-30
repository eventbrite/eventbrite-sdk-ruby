module EventbriteSDK
  class Resource
    class Attributes
      attr_reader :attrs, :changes

      def self.build(attrs, schema)
        new({}, schema).tap do |instance|
          instance.assign_attributes(attrs)
        end
      end

      def initialize(hydrated_attrs = {}, schema = NullSchemaDefinition.new)
        @attrs = {}
        @changes = {}
        @schema = schema

        # Build out initial hash based on schema's defined keys
        schema.defined_keys.each do |key|
          bury_attribute(ValueChange.new(key, nil))
        end

        @attrs = attrs.merge(stringify_keys(hydrated_attrs))
      end

      def [](key)
        public_send(key)
      end

      def assign_attributes(new_attrs)
        stringify_keys(new_attrs).each do |attribute_key, value|
          value = ValueChange.new(attribute_key, value)
          assign_value(value) if schema.writeable?(attribute_key)
        end

        nil
      end

      def changed?
        changes.any?
      end

      def to_h
        attrs.to_h
      end

      def to_json(opts = {})
        to_h.to_json(opts)
      end

      def inspect
        "#<#{self.class}: #{JSON.pretty_generate(@attrs.to_h)}>"
      end

      def reset!
        changes.each do |attribute_key, (old_value, _current_value)|
          bury_attribute(ValueChange.new(attribute_key, old_value))
        end

        @changes = {}

        true
      end

      # Provides changeset in a format that can be thrown at an endpoint
      #
      # prefix: This is needed due to inconsistencies in the EB API
      #         Sometimes there's a prefix, sometimes there's not,
      #         sometimes it's singular, sometimes it's plural.
      #         Once the API gets a bit more nomalized we can remove this
      #         alltogether and infer a prefix based
      #         on the class name of the resource
      def payload(prefix = nil)
        changes.each_with_object({}) do |(attribute_key, (_, value)), payload|
          bury(ValueChange.new(attribute_key, value, prefix: prefix), payload)
        end
      end

      def values
        attrs.values
      end

      private

      attr_reader :schema

      def assign_value(value)
        apply_changeset(value)
        bury_attribute(value)
      end

      def apply_changeset(value)
        changes.merge! value.diff(attrs, changes)
      end

      def bury_attribute(value)
        bury(value, attrs)
      end

      def bury(value, hash = {})
        keys = value.key.split '.'

        # Hand rolling #bury
        # hopefully we get it in the next release of Ruby
        keys.each_cons(2).reduce(hash) do |prev_attrs, (key, _)|
          prev_attrs[key] ||= {}
        end[keys.last] = value.value

        hash
      end

      def method_missing(method_name, *_args, &_block)
        requested_key = method_name.to_s

        if attrs.has_key?(requested_key)
          handle_requested_attr(attrs[requested_key])
        else
          super
        end
      end

      def respond_to_missing?(method_name, _include_private = false)
        attrs.has_key?(method_name.to_s) || super
      end

      def handle_requested_attr(value)
        if value.is_a?(Hash)
          self.class.new(value)
        else
          value
        end
      end

      def stringify_keys(params)
        params.to_h.map { |key, value| [key.to_s, value] }.to_h
      end
    end
  end
end
