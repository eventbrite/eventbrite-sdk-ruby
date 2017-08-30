module EventbriteSDK
  module Formatters
    class BaseFormatter
      private

      def method_missing(method_name, *args)
        if respond_to?(method_name.to_s.sub('.', '_'))
          public_send(method_name, args.first)
        else
          args.first # pass through
        end
      end

      def respond_to_missing(method_name, _include_private = false)
        respond_to?(method_name.to_s.sub('.', '_')) || super
      end
    end
  end
end
