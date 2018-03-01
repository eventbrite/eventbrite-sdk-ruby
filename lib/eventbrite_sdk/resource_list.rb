module EventbriteSDK
  class ResourceList
    extend Forwardable
    include Enumerable

    def_delegators :@objects, :[], :each, :empty?

    def initialize(
      url_base: nil,
      object_class: nil,
      key: nil,
      query: {},
      request: EventbriteSDK
    )
      @key = key
      @object_class = object_class
      @objects = []
      @query = query
      @request = request
      @url_base = url_base
    end

    def concat(other)
      other.concat(to_ary)
    end

    def retrieve(query: {}, api_token: nil)
      @query.merge!(query)
      load_response(api_token)

      self
    end

    def page(num, api_token: nil)
      pagination['page_number'] = num

      retrieve(api_token: api_token)
    end

    def next_page(api_token: nil)
      return if page_number >= (page_count || 1)

      page(pagination['page_number'] + 1, api_token: api_token)
    end

    def prev_page(api_token: nil)
      return if page_number <= 1

      page(pagination['page_number'] - 1, api_token: api_token)
    end

    %w[
      continuation
      has_more_items
      object_count
      page_number
      page_size
      page_count
    ].each do |method|
      define_method(method) { pagination[method] }
    end

    def to_ary
      objects
    end

    def to_json(opts = {})
      { key => objects.map(&:to_h), 'pagination' => @pagination }.to_json(opts)
    end

    def with_expansion(*args)
      if args.first
        @query[:expand] = args.join(',')
      else
        @query.delete(:expand)
      end

      self
    end

    private

    attr_reader :expansion,
                :key,
                :object_class,
                :objects,
                :query,
                :request,
                :url_base

    def pagination
      @pagination ||= { 'page_count' => 1, 'page_number' => 1 }
    end

    def load_response(api_token)
      response = request.get(
        url: url_base,
        query: { page: page_number }.merge(query),
        api_token: api_token
      )

      @objects = (response[key.to_s] || []).map { |raw| object_class.new(raw) }
      @pagination = response['pagination']
    end
  end
end
