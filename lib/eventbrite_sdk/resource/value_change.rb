module EventbriteSDK
  class Resource
    class ValueChange
      SIBLING_KEYMAP = { 'timezone' => 'utc', 'utc' => 'timezone' }.freeze
      SIBLING_REGEX = /\A(.+)\.(utc|timezone)\z/

      attr_reader :key, :value

      def initialize(key, value, prefix: nil)
        @key = (prefix && "#{prefix}.#{key}") || key
        @value = value
      end

      def diff(attrs, changes)
        initial_value = attrs.dig(*key.split('.'))

        if initial_value != value
          { key => [initial_value, value] }.merge rich_changes(attrs, changes)
        else
          {}
        end
      end

      private

      def rich?
        key =~ SIBLING_REGEX
      end

      def rich_changes(attrs, changes)
        if rich? && !changes[sister_field]
          { sister_field => sister_change(attrs) }
        else
          {}
        end
      end

      def sister
        if key =~ SIBLING_REGEX
          key_prefix = Regexp.last_match(1)
          sister_field = SIBLING_KEYMAP[Regexp.last_match(2)]

          [key_prefix, sister_field]
        end
      end

      def sister_field
        sister.join('.')
      end

      # Since we use dirty checking to determine what the payload is
      # you can run into a case where a "rich media" field needs other attrs
      # Namely timezone, so if a rich date changed, add the tz with it.
      def sister_change(attrs)
        Array.new(2) { attrs.dig(*sister) }
      end
    end
  end
end
