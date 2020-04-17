EventbriteSDK::Lists.module_eval do
  class DiscountsList < EventbriteSDK::ResourceList
    def_delegators :@objects, :index, :shift

    #
    # Params...
    #   scope: The scope to search within...
    #     "event"        - single event only
    #     "multi_events" - multi event only
    #     "user"         - any type associated to the user "All"
    #
    #   event_id: (Optional) - Only discounts for the given event.
    #   expand:   (Optional) - What, if any attributes to expand.
    #   term:     (Optional) - Search for discounts w/ code having the term.
    #   type:     (Optional) - A single value, or an array with the following...
    #     "access" - codes that unlock hidden tickets
    #     "coded"  - codes that apply a discount
    #     "public" - discounts without a code, publicly available
    #     "hold"   - held reserved seats activated via code
    #
    def search(scope:, event_id: nil, expand: nil, term: nil, type: nil)
      type = coerce_type(type) if ! type.nil?

      define_query_params(
        code_filter: term,
        discount_scope: scope,
        event_id: event_id,
        expand: expand,
        type: type
      )

      self
    end

    private

    def coerce_type(value)
      value = [value] unless value.respond_to?(:join)
      value.join(',')
    end

    # TODO: define in resource list and update accordingly
    def define_query_params(params)
      params.each do |name, value|
        if ! value.nil?
          @query[name] = value
        else
          @query.delete(name)
        end
      end
    end
  end
end
